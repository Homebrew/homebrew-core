class AwsRunas < Formula
  desc "Friendly way to do AWS STS AssumeRole operations"
  homepage "https://github.com/mmmorris1975/aws-runas/"
  url "https://github.com/mmmorris1975/aws-runas/archive/1.3.4.tar.gz"
  sha256 "4b1e3fe48e470d0705c0d3064aaa0fbb32086976b007137478e5a8499053ab77"

  depends_on "go" => :build

  def install
    system "make"
    bin.install "aws-runas"
  end

  test do
    system bin/"aws-runas", "--help"
  end
end
