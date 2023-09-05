class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/tags/0.11.1.tar.gz"
  sha256 "70529bc931288f8864ac84939d5cc3efb38bd7f72ff286029d32e476613e1b17"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66ab5e849feaba170f8e924e14096ba88974b20c5496c87893f2dcbda8544ed6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e04f55c40909d8ff314c2495ec61e4806a98112863d6229f4f18a83f3060ca10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b1a527afa2ff9a4942a039dc83d6db9a35f327d2ed9acd750624a6f6593abc3"
    sha256 cellar: :any_skip_relocation, ventura:        "8ae4ad16ea616ff477dc2216730621a8b06fc5265e1c4179942a75bc527939f6"
    sha256 cellar: :any_skip_relocation, monterey:       "852095d1f853b75ada0847f5b3a5ded5860ef6de82f944384eeafd9c0a051712"
    sha256 cellar: :any_skip_relocation, big_sur:        "8688436ea00709a9cd5e6cab8c4aab30d4df49c2a9ff33a347e0969bd6ff3db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67cd9415934d98ec61bafc1d8a6638330641bb551a2ae7e914a47665d2a107a4"
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
