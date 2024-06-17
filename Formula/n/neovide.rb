class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/refs/tags/0.13.1.tar.gz"
  sha256 "6cc2ddf50708a343114756d424b318c581c148437b96ba9563c401dfdb754408"
  license "MIT"
  head "https://github.com/neovide/neovide.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "053f5a69ef87d61891aab9809fe48f40bbdb64b72d282cec7e0b7c0b1ddb5204"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c04bce151e58ed54613a7f7e3f430fa9244ce7581ef5e4627dc0d63b350e9043"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7de1e55ca74e158cdfc6d00297f5a7445333d337458f37d1d86efc0ef649e5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "eaf53cbb3008a2a17171c10d162c79a7f70d1e5da0b405a6a9c09c3f332423a3"
    sha256 cellar: :any_skip_relocation, ventura:        "9ccb8283f738be5ef49de800cf607a2caa4c7c6a05d4c48a89a274bb37f2e143"
    sha256 cellar: :any_skip_relocation, monterey:       "ea11dec2a953a55471ecb5ea300d9eecde1934dd3191a6c62ab5ba6f473237a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a6b7dd59a8a6fd2f54f350d727a95386dbc4661a186c8a5d38d56167e39bd70"
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
