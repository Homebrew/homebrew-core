class Ec2AmiTools < Formula
  desc "Amazon EC2 AMI Tools (helps bundle Amazon Machine Images)"
  homepage "https://aws.amazon.com/developertools/368"
  url "https://ec2-downloads.s3.amazonaws.com/ec2-ami-tools-1.5.7.zip"
  sha256 "5a45d9f393d2e144124d23d2312b3a8918c5a3f7463b48d55f8db3d56a3fb29f"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2410a9e4734c4f4358ed678b90d51f610e0c60ab6dd47797c3b9514be8a95bc3"
  end

  depends_on "openjdk"

  uses_from_macos "ruby"

  def install
    env = { JAVA_HOME: Formula["openjdk"].opt_prefix, EC2_AMITOOL_HOME: libexec }
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
    assert_match version.to_s, shell_output("#{bin}/ec2-ami-tools-version")
  end
end
