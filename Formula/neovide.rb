class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/tags/0.10.1.tar.gz"
  sha256 "b94b5cc387b1aea03c6d967b738b487bf8e3ca876690716f34bd5ba6a7964d13"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "849472a47d23050706ea95fdb60db6673db0ce7252cca944a24f015129af2f08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51c0431fd0de684f5d79fb52503d60e5f04a8def7d0454e7dcb5dd4a9a1be480"
    sha256 cellar: :any_skip_relocation, monterey:       "e360687f741d93468bddc1b0ef97eba7e7b080b936ef479402a7416f6d4e7838"
    sha256 cellar: :any_skip_relocation, big_sur:        "a703232841516edaaddedd87b2e76db3cdfd6972698c2aaeceffee0b5deaa57f"
    sha256 cellar: :any_skip_relocation, catalina:       "d8fd3fed3846a4b67b316eb7c3d528cb6ff7dc5ffc8ce4416038506fb6d69f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e13a8e1107fc7e28a63367f41dd15a90b8addf4b89d65758a5bd1f6c8b55a1f"
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
