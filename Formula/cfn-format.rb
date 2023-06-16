class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.4.2.tar.gz"
  sha256 "fead74b5e0663ca598887d44f0c681e9a2501eccc8f7f1d816041c1b2531deb8"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7845e7c8424eac9d2fdc0c427fb68a656329deb71e2c33c7f6f707b802b2cb8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7845e7c8424eac9d2fdc0c427fb68a656329deb71e2c33c7f6f707b802b2cb8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7845e7c8424eac9d2fdc0c427fb68a656329deb71e2c33c7f6f707b802b2cb8d"
    sha256 cellar: :any_skip_relocation, ventura:        "6fd9483487a1f6f38de279f52905843c7ca5f9168799638db6c6a51939cf612b"
    sha256 cellar: :any_skip_relocation, monterey:       "6fd9483487a1f6f38de279f52905843c7ca5f9168799638db6c6a51939cf612b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fd9483487a1f6f38de279f52905843c7ca5f9168799638db6c6a51939cf612b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c4d90ae570b23316cec71c7d749f5571b6176b4c04bead2cf7e3bd0f357ae3d"
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
