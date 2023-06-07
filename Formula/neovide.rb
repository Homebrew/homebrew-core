class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/tags/0.10.4.tar.gz"
  sha256 "d3dd58884b0724db25f5d95ce8d0130689866a82ab20ee602e5ce852465a05a8"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53f6653ba07240b5556f1ffd7316da13c6ce42ce9058de63f781a8712b2c4eab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26b8c020ded5c68e8ed22fad358b78ff3931a8caf74b46831d0fc914449a0dbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c753b8fa4c81190201fb155a3d92d7f7d6e1953f7d13ca767eb631d08322be5"
    sha256 cellar: :any_skip_relocation, ventura:        "4059d660f957851cfd27cd1d345156af0107361769b5dc635cdd9d10f91837c6"
    sha256 cellar: :any_skip_relocation, monterey:       "8036c4aa9eded5c2ffc1f7d940b9a3bfbd1df875ddb2665510342e7d9aaa9fc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4252db5cb4745079dcd359699d87f702f04623dacc8676d87e561bd496b55f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82811eb83d6834822163801665e7e6c119a52bf5851df752cfbff9c1ac400f9"
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
    bin.write_exec_script prefix/"Neovide.app/Contents/MacOS/neovide"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/neovide --version")

    test_server = "localhost:#{free_port}"
    nvim_cmd = ["nvim", "--headless", "--listen", test_server]
    ohai nvim_cmd.join(" ")
    nvim_pid = spawn(*nvim_cmd)

    sleep 10

    neovide_cmd = [bin/"neovide", "--nofork", "--remote-tcp=#{test_server}"]
    ohai neovide_cmd.join(" ")
    neovide_pid = spawn(*neovide_cmd)

    sleep 10
    system "nvim", "--server", test_server, "--remote-send", ":q<CR>"

    Process.wait nvim_pid
    Process.wait neovide_pid
  end
end
