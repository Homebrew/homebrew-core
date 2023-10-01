class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/tags/0.11.2.tar.gz"
  sha256 "5b8da55e4910e2f4d6723e893d8b15de4c9d5b90023ab6717b52d6bc59c2563b"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ff9d9d484d69488d142f9fd2cca27c36e682fed70296198c01c59c22b5723f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3320e8ff1bfe32f6e6991e2f085579556cc8dafba8e29d3051961fed4083f081"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f03861852523ce88a982024633c498b5cb0203a3d59c6717d4e97ccc310c6dc6"
    sha256 cellar: :any_skip_relocation, ventura:        "55d3db2859c13550818835684d71058ce696f63c53620cb6808d463b123029e4"
    sha256 cellar: :any_skip_relocation, monterey:       "8fb81e056f2f6ff8c2fb89802144db4dfc00b56997140312af882dd0f35c7469"
    sha256 cellar: :any_skip_relocation, big_sur:        "94d03d2fea3210515f39bf4e8df046d58fbcfe0f60752f057b49fc6b6d0a4dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0109a12dc2265b0b956f420271b484328770a6438d0d614e4a7522c9c3f18fb9"
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
