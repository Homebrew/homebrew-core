class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/tags/0.10.3.tar.gz"
  sha256 "ea5a78caa7b87036950e4124e49e50f17b83677a29c251ffbbdc942a6768f022"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b81955808b6dff41670036729618b444988dd9172cee01c05615d91253197d20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eef70caf34d20b8b7da9802733e6b29a3b1a6d2026362a6e4166dab4d269349"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bcf85922313823ca963a6dfbf89d05e89ab499f7a61e295a3f19026f7ec3130"
    sha256 cellar: :any_skip_relocation, monterey:       "6c2e9372606b3929ffcb8593578ecb5b29691eae8115af45cfcd3fdd82a4463f"
    sha256 cellar: :any_skip_relocation, big_sur:        "725c1b866bdb3f98077bb9e0ef79bd7fdef923438e1f3ab855bb6bb98f8f411f"
    sha256 cellar: :any_skip_relocation, catalina:       "c7faaa51a145ef4a8c0ec66e539529308780b74b879d1b1f3390f33a1cb314ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d3e6c661f96394bb9de1087bf7be7d720da49567ab35e157a771d45160edecb"
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
