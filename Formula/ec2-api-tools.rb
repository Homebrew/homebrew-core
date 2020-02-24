class Ec2ApiTools < Formula
  desc "Client interface to the Amazon EC2 web service"
  homepage "https://aws.amazon.com/developertools/351"
  url "https://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.7.5.1.zip"
  sha256 "851abe30403ee1c86a3ebdddf5b4bffd7ef4b587110530feadf00954d9ae2f3a"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    env = { :JAVA_HOME => Formula["openjdk"].opt_prefix, :EC2_HOME => libexec }
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
    assert_match version.to_s, shell_output("#{bin}/ec2-version")
  end
end
