class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "67bc01d96245bdab4a4045554674e549896de45e2a4744cac9ccb02850fedb35"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "412ee1af8d26bc22e560be163c5d6163f2446197ae05eccaf49b544dc69edd10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92b81ef263d7c564cb1417fd48a4c85677e62c565088e83dd6985082511dbddb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7958259bd2d3370adf8d1738db2c002301e346fa818c47bea06d20b49a89c1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc573a8da2a74617107c5653cdb82fa2cf32465ea85147e3a007689f9455bd5c"
    sha256 cellar: :any_skip_relocation, ventura:        "b934b5dd8f70d05550c39a5551a71debc4b9b809da826a989ea4e20bf258b4cb"
    sha256 cellar: :any_skip_relocation, monterey:       "878c0fb20c13ec0ace2f71911d1e500232b090cc80c7583072adb0e3f17f6e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e505de7153fe13d5ec1f48c2aae1ae6cd38987bfc281e8abd88bcd47f00f32fc"
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
