class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/refs/tags/0.12.2.tar.gz"
  sha256 "5425c60454388651fd79757bde7c4d7499cdc49b375f7697b48d8366d45d08e4"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d490783c10a471b4cfa2cafa121be6d721b10aa2f16c1c943a8827aa496ef138"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9684319e29ea26414935c1d520bd36b302eaadf07ec6757dae200d8e1576765"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "311516b633572577408770531ff0dc14f0082ca0c038f516cb1bb282a91096e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7eed5e2e284b72450c963feb7192363b48da5a37b9884c7a2046d7ab3845de0"
    sha256 cellar: :any_skip_relocation, ventura:        "6cab1267913f46243b4e62aed5e6b71dba788fdb111a8a3b7f8d05075f8bd83e"
    sha256 cellar: :any_skip_relocation, monterey:       "f0108e38943d7fe7e85514fddea99c321efbbcc1b609bc328c162381ddfab483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c200cfe463ba8b2625e583b311e658562f2ba93bbe025c1967e4f521dac0ff13"
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
    test_server = "localhost:#{free_port}"
    nvim_cmd = ["nvim", "--headless", "--listen", test_server]
    ohai nvim_cmd.join(" ")
    nvim_pid = spawn(*nvim_cmd)

    sleep 10

    neovide_cmd = [bin/"neovide", "--no-fork", "--remote-tcp=#{test_server}"]
    ohai neovide_cmd.join(" ")
    neovide_pid = spawn(*neovide_cmd)

    sleep 10
    system "nvim", "--server", test_server, "--remote-send", ":q<CR>"

    Process.wait nvim_pid
    Process.wait neovide_pid
  end
end
