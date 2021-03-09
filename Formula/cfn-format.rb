class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.1.2.tar.gz"
  sha256 "c5004a0d63e09949d2d89f7368dda12e9bf137cc6804b3eaa35a5b1f55320010"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "053205f9da61e5f8011d21fedf564f25d2e15b4f32373e1e25b5a9d44a2d9dbd"
    sha256 cellar: :any_skip_relocation, big_sur:       "48e603a6ca9fb0ec806de448a1b43e3fad4329333d334caeadd32192126b2f04"
    sha256 cellar: :any_skip_relocation, catalina:      "4ddde47ea62313d1ad04715c287490fb08b463331a438a14acb1184b7debd4a1"
    sha256 cellar: :any_skip_relocation, mojave:        "c6c9b7832a4c5613d66dd7fa67d402dfbc7cd91dc5f935a6b389873c9544fc03"
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
