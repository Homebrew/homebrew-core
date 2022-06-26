class Ec2ApiTools < Formula
  desc "Client interface to the Amazon EC2 web service"
  homepage "https://aws.amazon.com/developertools/351"
  url "https://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.7.5.1.zip"
  sha256 "851abe30403ee1c86a3ebdddf5b4bffd7ef4b587110530feadf00954d9ae2f3a"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d0cd307194a156731087035900c915777ac2e6068c879088fe41b754a260766"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d0cd307194a156731087035900c915777ac2e6068c879088fe41b754a260766"
    sha256 cellar: :any_skip_relocation, monterey:       "b7cf3620699017c6f0b7ba925511319037313fa447361cb04d3add6d15de3c27"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7cf3620699017c6f0b7ba925511319037313fa447361cb04d3add6d15de3c27"
    sha256 cellar: :any_skip_relocation, catalina:       "b7cf3620699017c6f0b7ba925511319037313fa447361cb04d3add6d15de3c27"
    sha256 cellar: :any_skip_relocation, mojave:         "b7cf3620699017c6f0b7ba925511319037313fa447361cb04d3add6d15de3c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d0cd307194a156731087035900c915777ac2e6068c879088fe41b754a260766"
  end

  # Deprecated upstream somewhere between 2017-12-24 and 2018-09-09 here:
  # https://docs.aws.amazon.com/AWSEC2/latest/APIReference/Welcome.html
  # The current version (1.7.5.1) is from 2015-09-08.
  deprecate! date: "2020-02-03", because: :deprecated_upstream

  depends_on "openjdk"

  def install
    env = { JAVA_HOME: Formula["openjdk"].opt_prefix, EC2_HOME: libexec }
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
