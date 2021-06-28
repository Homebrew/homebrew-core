class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "d4f3f9366c22580d897142a35b5ab01685f090b10dace96f443d3440e53c742a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "88fc2f287eb1b68043454e7d39875b289f973852e4b5198e82f93e4b8ac80358"
    sha256 cellar: :any, big_sur:       "7268fe65e6c4d4b5152b6ed37b1e21055862a87380bf7d30a2c7215c871bca31"
    sha256 cellar: :any, catalina:      "d3c30b9ea6e214b5b6e7dfbada4992ba969ffc407e58e7cf0de1a7640dffcb10"
    sha256 cellar: :any, mojave:        "e5526a9ad95a5f97b493fdebbb8f9adbee09e44be372f81b1ca409c5b46e3204"
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
