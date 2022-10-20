class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/tags/0.10.1.tar.gz"
  sha256 "b94b5cc387b1aea03c6d967b738b487bf8e3ca876690716f34bd5ba6a7964d13"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61512b2f78a01c962ecf13c2e278132ee316d8689d54cabd67779790bc29e170"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38d8ebcc087d78c82dd4de73ad8c5193b24282e79c5219cd7708286817e24506"
    sha256 cellar: :any_skip_relocation, monterey:       "3c3a188230cee5a04dc9218b406cc0db3445924cfa88b1ec6d83825dd88cb824"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b037725a8be019e939b2e11d11b3c6d3fe559a89cf13558357c053e436fb466"
    sha256 cellar: :any_skip_relocation, catalina:       "b08fc23beb4353a0c8a3f0f92fb7d3687636bbc82cedf525c77af9a35949fb2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c1116998199528bf87425fcf9b8cc839bceabfc44344d0ba0e3d69f1d96843f"
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
