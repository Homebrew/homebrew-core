class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "6e7a87913f963afc349c8ee9da5ffa6732856df6eef63c930db72c3de1812f7e"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0879bc087f9fa2c0d426dc0489f8646dd7345aa62a61565b27e0619b2eceb8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bf1bce3cea42ee138aea07c975100d6ba88c92bfabb9590b2b8880bc9eb3cd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9e88a4edc933acbde07c9a22526f986dd8f6254006e909e1e59f324d804c55e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b391cdfaf938819001ffb0af443dc52ae18437f6f79503455d82bb39ed560538"
    sha256 cellar: :any_skip_relocation, ventura:        "2bff98707be66d9d147cc3a1fa11e2cffecddd4f115888356821d410fb0746d1"
    sha256 cellar: :any_skip_relocation, monterey:       "72c9c36171009d9a8497333ba85a7055176e0e16fa8f121178815396333238a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efca1f641625247318c546b406819316686c65584ef51ebd55eda9f2ccba5803"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/aws-console/main.go"
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end
