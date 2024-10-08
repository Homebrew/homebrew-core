class AwsRotateKey < Formula
  desc "Easily rotate your AWS access key"
  homepage "https://github.com/stefansundin/aws-rotate-key"
  url "https://github.com/stefansundin/aws-rotate-key/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "91568ad7aeb849454ac066c44303e2b97e158dc094a90af43c8c9b3dc5cc4ed7"
  license "MIT"
  head "https://github.com/stefansundin/aws-rotate-key.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a215e496204ec19a14b0c162b17f5bfa6a4bc0af37238d3c8fc7c88737b0461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a215e496204ec19a14b0c162b17f5bfa6a4bc0af37238d3c8fc7c88737b0461"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a215e496204ec19a14b0c162b17f5bfa6a4bc0af37238d3c8fc7c88737b0461"
    sha256 cellar: :any_skip_relocation, sonoma:        "411c5af053e3ad6e23196a054b04c98b1b17b247f4c4e02fbecbd6dd722667e3"
    sha256 cellar: :any_skip_relocation, ventura:       "411c5af053e3ad6e23196a054b04c98b1b17b247f4c4e02fbecbd6dd722667e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46dc80d32c322061ff4d64527cc0e9e01dbe12d6f9b015434f75e446d18c409f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
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
