class AwsRotateKey < Formula
  desc "Easily rotate your AWS access key"
  homepage "https://github.com/stefansundin/aws-rotate-key"
  url "https://github.com/stefansundin/aws-rotate-key/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "91568ad7aeb849454ac066c44303e2b97e158dc094a90af43c8c9b3dc5cc4ed7"
  license "MIT"
  head "https://github.com/stefansundin/aws-rotate-key.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51c9c9e83de0683c2a79db2c926ed216dd5801602bd2a7796386a64f0964d258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51c9c9e83de0683c2a79db2c926ed216dd5801602bd2a7796386a64f0964d258"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51c9c9e83de0683c2a79db2c926ed216dd5801602bd2a7796386a64f0964d258"
    sha256 cellar: :any_skip_relocation, sonoma:        "9430280fe49a0045dbb0664c3c29e8159e4716d87a33bc66a68cf2247a311219"
    sha256 cellar: :any_skip_relocation, ventura:       "9430280fe49a0045dbb0664c3c29e8159e4716d87a33bc66a68cf2247a311219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c01910c4f482e31fa3f2980df4a370d7b7482ee199f16f47f2414d58ced1fc3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"credentials").write <<~EOF
      [default]
      aws_access_key_id=AKIA123
      aws_secret_access_key=abc
    EOF
    output = shell_output("AWS_SHARED_CREDENTIALS_FILE=#{testpath}/credentials #{bin}/aws-rotate-key -y 2>&1", 1)
    assert_match "InvalidClientTokenId: The security token included in the request is invalid", output
  end
end
