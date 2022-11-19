class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/tags/0.10.3.tar.gz"
  sha256 "ea5a78caa7b87036950e4124e49e50f17b83677a29c251ffbbdc942a6768f022"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9f0ee8191ec79f9fbd3438d10c5ae0493863c7c2c680caab4fc967fc168148a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52e1a6e4f4f2a2e918e365e0105cac14e241f64de52a46f406df9955377bc470"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e51d21a37542931d1fbdbfb8d14ee678620a125231e23e896b1ba2e5bd7fcc8e"
    sha256 cellar: :any_skip_relocation, ventura:        "93ea527c2ae7cd5fc549c337afbea69bcd9e11cd5f4cb03ef365e55b0edec9ee"
    sha256 cellar: :any_skip_relocation, monterey:       "7dba3e47469e140aefc423a6d82f5e3123052577973c0569cfbb648d3c379504"
    sha256 cellar: :any_skip_relocation, big_sur:        "a037d1e850fd22743a0a0c2df4a7d698721d7a1777c08d5ec31101fbe2262503"
    sha256 cellar: :any_skip_relocation, catalina:       "a216d673f01cedf9ee649425df9433e0882465f7cdfd6a5afca3a91ccb81f9da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f0d267c95c4cdd59f9054ad1ed28727b0dd89cc53a77988d77dfad49e3f95a3"
  end

  depends_on "rust" => :build
  depends_on "neovim"

  uses_from_macos "python" => :build, since: :catalina

  on_macos do
    depends_on "cargo-bundle" => :build
  end

  on_linux do
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
