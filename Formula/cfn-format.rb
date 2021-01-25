class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.1.1.tar.gz"
  sha256 "5faf25a87a6fc0fde19edcf2fe6f26c81990da91d13fbf3858b1eb33711b0ebd"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "736d8ccf911a2de6edeff90bed1ffe207ea9e1c21c0fd09c1afb724400152703" => :big_sur
    sha256 "78cf14405e2bc20b7914cb2e357b5f806fd8a89bdb65792e5d2049a87dce32e3" => :arm64_big_sur
    sha256 "3ffc8a003adc05637ed75636c41249452feb297d72b40227699681529b8b66ed" => :catalina
    sha256 "d68a3331c643ee79c0b815dbe655ef5773e0a9e5e2c6b9f4f8fb2d7112bfeafb" => :mojave
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
