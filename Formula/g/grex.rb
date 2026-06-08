class Grex < Formula
  desc "Command-line tool for generating regular expressions"
  homepage "https://github.com/pemistahl/grex"
  url "https://github.com/pemistahl/grex/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "2ab9cb4c3d921711f23ea33a9e60dc11e9eaab450b16d1f2247bea2276822433"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "030f136816a772a582ac3db3b5ec654f2cfc6b5e8c22578f5e9d18c2b01ae4cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbe575583c67bfca42c2d611667344884f3b920dbefa0ac5c6009932056fe70d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92e29f2ea3d5978f6f08a40e68d0f46a620651cefbab8abbb62bac1c53507d40"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e3e2f535113940e271df53d0d7057ea92f226085e7466e86093a4d2c6597f2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "816de4349a92fd6750e0b3e788a52299cc06419755664689cf9d9ffd68b2bd93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "661eb34ec8341b463464dcbc6e4a55b971b6cb7a1c2a6c46e123f4e643cb1cfc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/grex a b c")
    assert_match "^[a-c]$\n", output
  end
end
