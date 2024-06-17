class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "ef6dc71698ad7d8caf1cc9d0d6a64aaf8bbc21d2449c0af804a2146c23950f91"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd2678495b8af89895f82df31249388e7162ae1205f9a496ad374a2463da5abc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2277bd4ce77aab29c44617d9d1d3a9a21f4cf6fc7d796e87539d00fccf00ca9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad4909bff2322106437b97fba71c944109dc090d4f60916d4a8c0950ecf7ca57"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bda9a077685c67e60d62f0792b45e461a672940369eaee6ad60fd8ed08782ea"
    sha256 cellar: :any_skip_relocation, ventura:        "f876cc78936763bb11653f23d5033019b3c7566f32daaa331732ec443a0449be"
    sha256 cellar: :any_skip_relocation, monterey:       "effa16b5f78661f0113bd6d2a9f803ccb1cea354159f891cc451a6072cf57920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f26b12992a16dcd946ed0ecc44272f4f71d071a0846b5e644ed4d686d86c6ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/cfn-format/main.go"
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end
