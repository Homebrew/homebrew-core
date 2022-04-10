class AwsRotateKey < Formula
  desc "Easily rotate your AWS access key"
  homepage "https://github.com/stefansundin/aws-rotate-key"
  url "https://github.com/stefansundin/aws-rotate-key/archive/v1.0.8.tar.gz"
  sha256 "84a0df21f8ec4e1816094136c7ed4c8a559b3f74e32b5ac58a9a3f25582e7f2a"
  license "MIT"
  head "https://github.com/stefansundin/aws-rotate-key.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8803eb6dd3cc04a1ff658fe15a7a4a209a16e67ffa7e64124c83bb06ff2bb6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "139378379b2bf12f02aa6e4efb483206dffbdddba1046c8fbead4e7c4d3d83fc"
    sha256 cellar: :any_skip_relocation, monterey:       "190541bbff030ea97a0e974126ede294dca660806ff3b8a07d7a5709813676f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "220153a7b95de73d476982bdae9dfff35e4d4e98160736dd0c5a8ef20d233bc5"
    sha256 cellar: :any_skip_relocation, catalina:       "b56158ccb02c1a7e0b1277f30768daaaf73601717e412761d19abf44102e00a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "656c139c8b8c7b080f1204d7f993ec734432eff02789115171ff2fbb8a362992"
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
