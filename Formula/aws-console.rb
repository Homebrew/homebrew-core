class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.3.3.tar.gz"
  sha256 "230db11449b34043dc9e10a009134bd5dca240dc20a5d12710b98606f62559a7"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9e8aa96e7240088e5e771eca7369e02c96e69b6cfee4c57c902d33cf963147f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efdf1c94b4c17ee8de0db7bebd5e826f12b89f07f60d74f803eacf563499040c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84fd08fed0a2fb95c7f7da833c3a4ab4895ad1fb469fe7fdae21ab4a29a07b8f"
    sha256 cellar: :any_skip_relocation, ventura:        "142c0c9fedb515487bd229f5c89cc78d7c973c156706c8678dd0381e471f4bb5"
    sha256 cellar: :any_skip_relocation, monterey:       "d6a6b226f32edfde3f1771b94c89e6a259c134760343217736bb2f939b196c45"
    sha256 cellar: :any_skip_relocation, big_sur:        "d01062d636760a09fe2bf558dcf5e2428d03b30770505fd0eb70779e30e685b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7954ac0504bfef877b06012205223cb8f40070ce948cd697ea4525c01f4151fb"
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
