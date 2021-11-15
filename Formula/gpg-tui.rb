class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/v0.8.1.tar.gz"
  sha256 "167e4c48a9769a6b2ca4cb32374e203fb1c52d27a6da52518eaccf17a6e0e038"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "89e9f24b67d35358860b93d0ca33b1a78a3d3fcfb18a431306e4a196740a4ccd"
    sha256 cellar: :any, arm64_big_sur:  "76f4694e7e26315597a7b5ca3f7c5d115128f859d2693eded12b732f4b61e99f"
    sha256 cellar: :any, monterey:       "a048df27a97c9dfed8cb2876baeb0b4da1be5561485bf0a03ec1a290cce07751"
    sha256 cellar: :any, big_sur:        "db37af3c36e7b10f326d2ed5c8d5bddafc07203e1c846e2706f43356a22cfaab"
    sha256 cellar: :any, catalina:       "c95fbfb237ea576e25e5ddf56efa1044c994279d9cbf53460153b551e8eef1ed"
    sha256 cellar: :any, mojave:         "1dc1aa3b1a3a7f13c431ff73d06a4bb98ada95e58c3f8db908202932e269274e"
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
