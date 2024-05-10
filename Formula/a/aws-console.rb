class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "67bc01d96245bdab4a4045554674e549896de45e2a4744cac9ccb02850fedb35"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2597acc9e7d1d6c75a9a1fbe6b5e5df39809214f865d7d37f7d4daa40d661e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abfb45f9cd0c38c567234fb3e698d89e874c9bc352101a6776f4613da647c946"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd3e8f2348dadd339219938fd223172de63c7b165f6337fcd7b443ee2a20094c"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf10ef14dc23b9d92550b184b50ec5c1cddf75b28e1a70cbf2ba2c3f516f7d70"
    sha256 cellar: :any_skip_relocation, ventura:        "9479d4ffd9dc1545b99f5063f37d92b4d0f03385698b74b8e0f6b3461fb90cdf"
    sha256 cellar: :any_skip_relocation, monterey:       "146e1cf4da5284c396ec8a1420d587655e2ebcfa77e6de6ae09932b30092e9e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c046614198a9ff5f4ada0eb81e4709494c8a85921d1daa19eeb92f1956e513d"
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
