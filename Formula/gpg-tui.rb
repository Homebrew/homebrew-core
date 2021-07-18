class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "acb13a51e5c3eaa1a26864a578f3398e09cb73c04bf545ab8542809e2aba21cd"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "26261ddc9d1ad5ddfe9b7d25347c4302c945539206d28095e9a479ea61e26d64"
    sha256 cellar: :any, big_sur:       "46a12e12bd7673cb851650a0c17122f757633efd9d0e6f577002cc61bbd1981b"
    sha256 cellar: :any, catalina:      "3fae4cb020c7a6f47faee651c8dda3e2b4949bccbfc1ddfcf8cf8b9644f3a4b9"
    sha256 cellar: :any, mojave:        "31e492cf2d8d0b2012ea35c32de589fe3117eb75ed0529010bdc57a11e01b88c"
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
