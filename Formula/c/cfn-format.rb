class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "6e7a87913f963afc349c8ee9da5ffa6732856df6eef63c930db72c3de1812f7e"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "919f17f9fda22333fa47470dbde30e523b22454ae187140d7a9a8b5f8c8c5586"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9693182d66af47de5a7aa3652f419799d6b9bd7e5393c38c8c41a3d8da854f6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2fea18ab65b92a0a9a6ae99a9d40427f1635cdbe8d2b4e3d3c936e6a795712b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5195aa4e7a12413afbad0c24e429d319bf18bcdcc473d87e93c27b4fceb047ef"
    sha256 cellar: :any_skip_relocation, ventura:        "4acb0331b68dc0985a75544dad1d8a409491ffba8ac5f1c34e41612f56b5c9f7"
    sha256 cellar: :any_skip_relocation, monterey:       "809aea209b9bdce57d7fa6bc566af31c6037ada538916276356637ce005c6bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef749b00601da7e6edc4932510363ef5e4c913ccd7bcc8da8b111ca6d7157420"
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
