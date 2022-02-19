class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/v0.8.3.tar.gz"
  sha256 "64e0159c997b97fc6896ed6fb5e50d65d50e6c08c14817bea7b9be5a70335442"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "80658ddf190a8bd7f6340228711c720f97df9b4dd12d0e730a96e9b8709c3ad9"
    sha256 cellar: :any, arm64_big_sur:  "e25048955a1e3cb99503c2d8d1ac6cfac710483ecb3137e814c12e2ab9ef3c28"
    sha256 cellar: :any, monterey:       "b33057a7e89af4774375ca73fd7243f1e6f4b8bb01e2ed4421dadbf5c4e3040d"
    sha256 cellar: :any, big_sur:        "80fc70bffb4066c16ebab3274d4913113460498f4cc4a09680fec03bf25c481a"
    sha256 cellar: :any, catalina:       "2e3e441ddd15e7b67b409e582b96e634ac12831e3f480c3e8fcb6166fc982191"
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
    r, w, pid = PTY.spawn "#{bin}/gpg-tui"
    r.winsize = [80, 43]
    sleep 1
    w.write "q"
    assert_match(/^.*<.*list.*pub.*>.*$/, r.read)
  ensure
    Process.kill("TERM", pid)
  end
end
