class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/v0.9.1.tar.gz"
  sha256 "876d9dd34e575c230fc63558e5974830b71a4c092a885526dfdbc19aba31c610"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ef7e0576b4914ac1512731c22387a9b7b4aea3320d55f697bbda1245ea4448e7"
    sha256 cellar: :any,                 arm64_big_sur:  "b0c6f1cfb61dd6be121d5f2653b517bb5c2f0ecceaa3d111f4cba2a243d9a8fc"
    sha256 cellar: :any,                 monterey:       "b257a8c7f576d59f4a1d18b353b940f146b16683b30ae7d35644f94d0449e6b7"
    sha256 cellar: :any,                 big_sur:        "41d5a21cb96a55b92528d6999d4a7c52a5a055e0982fcd61e1929b972f3939eb"
    sha256 cellar: :any,                 catalina:       "70be11f66733d29e745854a0d7b174b9ede6f728a3145c690e18cf3666857409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c79970c8a9798c1a69d6f44b46f56ffef2420ad1b54686af9fd9cdd111adb4a9"
  end

  depends_on "rust" => :build
  depends_on "gnupg"
  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "libxcb"

  def install
    system "cargo", "install", *std_cargo_args

    ENV["OUT_DIR"] = buildpath
    system bin/"gpg-tui-completions"
    bash_completion.install "gpg-tui.bash"
    fish_completion.install "gpg-tui.fish"
    zsh_completion.install "_gpg-tui"

    rm_f bin/"gpg-tui-completions"
    rm_f Dir[prefix/".crates*"]
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"gpg-tui").mkdir
    begin
      r, w, pid = PTY.spawn "#{bin}/gpg-tui"
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match(/^.*<.*list.*pub.*>.*$/, r.read)
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
