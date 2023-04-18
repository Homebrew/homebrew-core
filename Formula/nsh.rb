class Nsh < Formula
  desc "Fish-like, POSIX-compatible shell"
  homepage "https://github.com/nuta/nsh"
  url "https://github.com/nuta/nsh/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "b0c656e194e2d3fe31dc1c6ee15fd5808db3b2428d79adf786c6900ebbba0849"
  license any_of: ["CC0-1.0", "MIT"]
  head "https://github.com/nuta/nsh.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed0302eb6517ce8ab878bf1dce1954a16242a2dbc211d266f9773590aa1822e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cef76f0a812b0fe8ec3c23e9ceaaa5c2c671f418bd0aa5103972439c9544144"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afed7ecb9b4cd75cf529db0b5c035bee623b2d59e713d2f543cd61e4ab28e1a1"
    sha256 cellar: :any_skip_relocation, ventura:        "3c342fc7f7b6f3ef1fe471cfc73d457e4c53acbbbb6db12e7c89a3881e221a39"
    sha256 cellar: :any_skip_relocation, monterey:       "714f185da8a9912b95aacec6c43943eaf178afc960442ab6d131bbb58abdb79e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ca1f1cd16b32c731c9702b80c3524071431823ee7df7f833b30e89725019783"
    sha256 cellar: :any_skip_relocation, catalina:       "befe47c8ab9779445203caa06d3dd002f69967742a1483cc6f6f4ca54da65f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2459f1a58f38485536f990ac8e8817721e7fec5e313934af0ae00cc3d897f7b1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "hello", shell_output("#{bin}/nsh -c \"echo -n hello\"")
  end
end
