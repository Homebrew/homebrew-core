class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "6bbcf891e4d3e2b31a9d7878a4812d84ceb3b3ad294929b7577a68169a66dd3f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1e149278fb3515d297b3f1a019de3d17cda1fb94b3e0ed75035b001d22f14d1c"
    sha256 cellar: :any, big_sur:       "eba1aea45ce9d124a5ab412e633cee840848d1767f22764c809e6707e7e777a0"
    sha256 cellar: :any, catalina:      "b36bd03e3b44a7daad1abb3cc7ca0a78b4e29abcbf676a9791bdd62e58e9e720"
    sha256 cellar: :any, mojave:        "8046f5196da30d5b297b740b48f214f383ea0d147806818c45b7a5ade97f8910"
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
