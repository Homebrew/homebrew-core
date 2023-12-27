class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/refs/tags/0.12.0.tar.gz"
  sha256 "8770dd6977605f9bafa990a60cf8f2ebeba7df16417dab2e8c5583d279ec86ef"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "915e6a3608d721d354f46303aef2379a472d27cd42e00d757745187375ccb5b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04d7d884104c56ba7079594adb71942b694f5b162355f74918d51ee5ab38468f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3eece4f618a8a03f744bc1fefc509143f426f448df70ef8f4ca37b306dddff63"
    sha256 cellar: :any_skip_relocation, sonoma:         "10ba2be05acd0e059cadf25785681045e6fe334035f6e40f9201c730d00ff8fe"
    sha256 cellar: :any_skip_relocation, ventura:        "95c1448f5f704660a51c9ba65cef5288241038dcfc606a7a36f2635438843693"
    sha256 cellar: :any_skip_relocation, monterey:       "37050c0b6b6ad2eca47d30139475f4d10bd69f09bf575a30e7e39b2df95f39b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27aab4a6ec120ba91c5cc773d71fc538e8a84d0b9ed96cf04057a59f78dd4276"
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
