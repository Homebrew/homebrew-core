class AwsRotateKey < Formula
  desc "Easily rotate your AWS access key"
  homepage "https://github.com/stefansundin/aws-rotate-key"
  url "https://github.com/stefansundin/aws-rotate-key/archive/v1.0.7.tar.gz"
  sha256 "9dadb689583dc4d8869a346c2e7f12201e1fe65d5bf1d64eb09b69f65518bc44"
  license "MIT"
  head "https://github.com/stefansundin/aws-rotate-key.git"

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
