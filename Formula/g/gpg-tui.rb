class GpgTui < Formula
  desc "Manage your GnuPG keys with ease!"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/v0.9.6.tar.gz"
  sha256 "ee07347b1a354b39449ed2c1c97acb719c7d35d914002ba1ebaee0ab6e49bc85"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c129d514014a9e0e9644f32c90db2739254411effce254e13a128b31a32cedb6"
    sha256 cellar: :any,                 arm64_monterey: "6de667ecfdcc716c863c1ccb9d5c473115cda024e14f93e750acc452175e9bc3"
    sha256 cellar: :any,                 arm64_big_sur:  "6307fff5e450c615d843cc85711da3917cc36e06286f3236f85f0e59f7aa2fee"
    sha256 cellar: :any,                 ventura:        "a528cf1a064bf1713c1ce1856d8e39651fb22301e72ff01ff250e2aed0447c03"
    sha256 cellar: :any,                 monterey:       "7c0bcb664bc722f707c9eae864d6377cad12ee6a2a50d55ed4304899a54b7598"
    sha256 cellar: :any,                 big_sur:        "43bf620f0b82f5f066e784b91b561287299495e6de364ec25edf00d2d73a45f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67a24c19e69b98a14c90afafa6f1d4da2f50c53b376808bd20effe1e6711da7"
  end

  depends_on "pkg-config" => :build
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
