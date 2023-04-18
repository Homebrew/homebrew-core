class AwsCfnTools < Formula
  desc "Client for Amazon CloudFormation web service"
  homepage "https://aws.amazon.com/developertools/AWS-CloudFormation/2555753788650372"
  url "https://cloudformation-cli.s3.amazonaws.com/AWSCloudFormation-cli.zip"
  version "1.0.12"
  sha256 "382e3e951833fd77235fae41c1742224d68bdf165e1ace4200ee88c01ac29a90"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62fe9878c486068d70c77637c2b2ce55d3f4fbb07b6aba7c65ecd8f1aaaee7c4"
  end

  disable! date: "2022-08-04", because: :deprecated_upstream

  depends_on "ec2-api-tools"
  depends_on "openjdk"

  def install
    env = { JAVA_HOME: Formula["openjdk"].opt_prefix, AWS_CLOUDFORMATION_HOME: libexec }
    rm Dir["bin/*.cmd"] # Remove Windows versions
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      basename = file.basename
      next if basename.to_s == "service"

      (bin/basename).write_env_script file, env
    end
  end

  def caveats
    <<~EOS
      Before you can use these tools you must export some variables to your $SHELL.
        export AWS_ACCESS_KEY="<Your AWS Access ID>"
        export AWS_SECRET_KEY="<Your AWS Secret Key>"
        export AWS_CREDENTIAL_FILE="<Path to the credentials file>"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cfn-version")
  end
end
