class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/tags/0.10.0.tar.gz"
  sha256 "3ae859b3f1ba5e733d413071e3a33082350ca6bf14500b437a2259c5d5c4b706"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57b422b9f77432bc1b86525154544118eaadaa979e0f75f31902dbd391e4a13c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4368fe7d62d5cb3badaeb6df4c4b0c57bbc99eeb704254f60b68f1f4547dde73"
    sha256 cellar: :any_skip_relocation, monterey:       "322b08968b36531c6e2aacefb28614c8061a49478b1041383ab47cf00b2d9e59"
    sha256 cellar: :any_skip_relocation, big_sur:        "84b78067f83ad6e54330012bf16339bfecdb347287abc10ab78dfe6729a183d4"
    sha256 cellar: :any_skip_relocation, catalina:       "cca988f7a7d89732a8c7a35c4e0d8236555b77437842353dc3510c274715aa3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc3a8ca19e8f8eef623b85acfb501bcb834af528091c9c768b9b4a8a451bd483"
  end

  depends_on "rust" => :build
  depends_on "neovim"

  on_macos do
    depends_on "cargo-bundle" => :build
  end

  on_linux do
    depends_on "python@3.10" => :build
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args

    return unless OS.mac?

    # https://github.com/burtonageo/cargo-bundle/issues/118
    with_env(TERM: "xterm") { system "cargo", "bundle", "--release" }
    prefix.install "target/release/bundle/osx/Neovide.app"
    bin.install_symlink prefix/"Neovide.app/Contents/MacOS/neovide"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/neovide --version")

    test_server = "localhost:#{free_port}"
    nvim_pid = spawn "nvim", "--headless", "--listen", test_server
    sleep 10
    neovide_pid = spawn bin/"neovide", "--nofork", "--remote-tcp=#{test_server}"
    sleep 10
    system "nvim", "--server", test_server, "--remote-send", ":q<CR>"

    Process.wait nvim_pid
    Process.wait neovide_pid
  end
end
