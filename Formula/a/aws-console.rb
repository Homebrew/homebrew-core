class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "1bf031347ff0e3f51b16575639c6e6fc64fd2e7979a4f7678bfeb313fb5a2c7a"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "931eb2880158f49f34a4a717eeed64bb1a43fc2838d20707f8485cd06ccf3202"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "931eb2880158f49f34a4a717eeed64bb1a43fc2838d20707f8485cd06ccf3202"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "931eb2880158f49f34a4a717eeed64bb1a43fc2838d20707f8485cd06ccf3202"
    sha256 cellar: :any_skip_relocation, sonoma:        "686a6236592d688210ee5a6270e8f857edf78f16df9c2593b0e259862ce909c7"
    sha256 cellar: :any_skip_relocation, ventura:       "686a6236592d688210ee5a6270e8f857edf78f16df9c2593b0e259862ce909c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec7b41beea6c69706164965db0ecdf45e2279cb69a1d29ef0bc2a1c8e072c92a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/aws-console"
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end
