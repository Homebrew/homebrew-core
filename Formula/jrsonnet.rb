class Jrsonnet < Formula
  desc "Rust implementation of Jsonnet language"
  homepage "https://github.com/CertainLach/jrsonnet"
  url "https://github.com/CertainLach/jrsonnet/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "2396c57a49a20db99da17b8ddd1b0b283f1a6e7c5ae1dc94823e7503cbb6ce3f"
  license "MIT"
  head "https://github.com/CertainLach/jrsonnet.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "059cd2549df2910dcc08b405fe9a927057d44cad1f63ebf222304cb3489c8ff2"
    sha256 cellar: :any_skip_relocation, big_sur:       "88dca211837dfb36ffbcb6b5b5efb0d7245f82f2885e3c537b7ca96ff856ffe6"
    sha256 cellar: :any_skip_relocation, catalina:      "dddef69f27bd0ed421cc3d2458ee98dc236b0348b9592f8bc199e8db00100cfe"
    sha256 cellar: :any_skip_relocation, mojave:        "2aa7a841332b726e21ea560d3b62f9c35b17e42da6b464fca0099dee0d432fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46450b3bffee8cef6cdb5c7b7db6449636bc28153630e718b9895cdbfce6d4e1"
  end

  depends_on "rust" => :build

  def install
    cd "cmds/jrsonnet" do
      system "cargo", "install", *std_cargo_args
    end

    bash_output = Utils.safe_popen_read(bin/"jrsonnet", "--generate", "bash", "-")
    (bash_completion/"jrsonnet").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"jrsonnet", "--generate", "zsh", "-")
    (zsh_completion/"_jrsonnet").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"jrsonnet", "--generate", "fish", "-")
    (fish_completion/"jrsonnet.fish").write fish_output
  end

  test do
    assert_equal "2\n", shell_output("#{bin}/jrsonnet -e '({ x: 1, y: self.x } { x: 2 }).y'")
  end
end
