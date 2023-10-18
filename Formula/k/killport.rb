class Killport < Formula
  desc "Command-line tool to kill processes listening on a specific port"
  homepage "https://github.com/jkfran/killport"
  url "https://github.com/jkfran/killport/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "f1efcce989196417dd71e12fcf72550d135d7dbf5cffb4a96278f603f0695b36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12b99fb9b7b08db9f87d76836ce91b5c6be927c1edf963ec2805e7e2316c5292"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d801ff5969ea060ee5bb689073d831810e15103222fec5a9e0d418bd3c7de815"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07758231607878325924de6a6ab137675ce22e5cfc5bcf956bd590af581d8eae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "767fb8411a66b16b14fd07ce8bfac0566595ef4965f14333799f27d8c68e8756"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a4e327cce7bb5fbae0ac8a609389bff33046ba5fb26352b95a1dacb0fd43066"
    sha256 cellar: :any_skip_relocation, ventura:        "095f9c94e2a55766ef7141b6b3726189c597f5ac1a56434d8ba9efb4c66fdc69"
    sha256 cellar: :any_skip_relocation, monterey:       "9362f857a7de53e73703254a1e5e435f7b58757985a49e3c97e34e37b4ab76a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d11a3478da9d7f992bafb727c2d312864233c59ae58fb64d6d91822661e47348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edb7359ba32beb946cb51ede12dbdf27ccad2fcebcb0c0f84b6a9521e840a82c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    output = shell_output("#{bin}/killport --signal sigkill #{port}")
    assert_match "No processes found using port #{port}", output
  end
end
