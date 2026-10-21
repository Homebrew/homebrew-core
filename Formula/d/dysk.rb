class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v3.8.1.tar.gz"
  sha256 "8da0e478a6027803043149c63c84abbb0dd4b3538372b8d854c2f8cab8215f41"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b452a8815a396dc0ef3e453a975c6e58dfe3ba78fc1ea103a061d2863460f6ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07dfd95a593070403a631565f23fa856cf2d1665862d1fd7b5fe57fc7c2d1c41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dabf17608eb5849f7dda1d910395aa106705e204c87fe6fd2a5ced9b99aa6235"
    sha256 cellar: :any,                 arm64_linux:       "2a34b761a1039041cadf412da6f40aaafe8fb860f9cb06aa7ed9afe4e7a0ec10"
    sha256 cellar: :any,                 x86_64_linux:      "c0b1d6a56528a500018eada6305a4c6b22f5c29c0a10b117e4285b809dec5e6d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end
