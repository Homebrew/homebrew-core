class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "dccb0ca38f914ef450c422cd27423f1df2c2abf25fc3e58ab388d08efdebe762"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d90b031ef52e52d28147e9e740f46001648cbafb32fb8e0858bb3375292895d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "138d582064cb85b680c2296ded5d8ce98356a6621d973c233d7e56e3c8a7bb77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8855227d07c9cd4eb19b2edde90111acedf136cb0d8d12d5d347280dfb0d903"
    sha256 cellar: :any_skip_relocation, sonoma:         "d434e97bf3109bbd7732b45490ba675170abcad316430b6d3feaf9eae2efb208"
    sha256 cellar: :any_skip_relocation, ventura:        "7778857acf7c192df3283d10358622d619ab888966d696ec2e6febe5cb302569"
    sha256 cellar: :any_skip_relocation, monterey:       "46a17eb5f1f50e6a76b75506a524c2a5205ea64554488d8ef48ea3da09a8142b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65555647fb4cf78d422b337df85811780905c6fd53c9f0424e1a2b2f53bfd4b9"
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
