class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "c7ad50bb29f3403f7baa0d7520da9a5ddc82c0122c2684f7142e34bb3117ec86"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6335780267edd7863dde86b85c81d5907e2533ec643dd932f51b9f91b0081a85"
    sha256 cellar: :any, big_sur:       "b16361681638fe19e7ba5c640fe5332fb977858bc84e1e1f152dca1b2b17bb00"
    sha256 cellar: :any, catalina:      "21c99cb1f027f2970772484355aae9b6692a3b80cd5fad111783495fe9ada58c"
    sha256 cellar: :any, mojave:        "09b26782d983be3c4e9c9f1723807ac0690e0ac789650a42dc8b2cd301cdb96b"
  end

  depends_on "rust" => :build
  depends_on "gnupg"
  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "libxcb"

  def install
    system "cargo", "install", *std_cargo_args

    ENV["OUT_DIR"] = buildpath
    system bin/"completions"
    bash_completion.install "gpg-tui.bash"
    fish_completion.install "gpg-tui.fish"
    zsh_completion.install "_gpg-tui"

    rm_f bin/"completions"
    rm_f Dir[prefix/".crates*"]
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"gpg-tui").mkdir
    r, w, pid = PTY.spawn "#{bin}/gpg-tui"
    r.winsize = [80, 43]
    sleep 1
    w.write "q"
    assert_match(/^.*<.*list.*pub.*>.*$/, r.read)
  ensure
    Process.kill("TERM", pid)
  end
end
