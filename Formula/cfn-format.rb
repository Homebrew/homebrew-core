class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.1.1.tar.gz"
  sha256 "5faf25a87a6fc0fde19edcf2fe6f26c81990da91d13fbf3858b1eb33711b0ebd"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0e2a6e2e90e084941915f907daa408d5ff087a97e73efdf340d57e8c28f6fd1" => :big_sur
    sha256 "19a2772cae2dad769fd8170a18c9f8e16a02466a74c9cb0ddf4becea49b0abf0" => :catalina
    sha256 "3094a879f0d338e65d0b0ad77f20954fb415a22ae98f4cb853bf78c3f4fa74aa" => :mojave
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
