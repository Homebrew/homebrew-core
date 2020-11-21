class AwsRotateKey < Formula
  desc "Easily rotate your AWS key. 🔑"
  homepage "https://github.com/stefansundin/aws-rotate-key"
  version "1.0.7"
  url "https://github.com/stefansundin/aws-rotate-key/releases/download/v#{version}/aws-rotate-key-#{version}-darwin_amd64.zip"
  sha256 "972d52f480c8e6efe1d2b2a95756a5eef6dff595281b17126b39bc768eee3b9d"

  def install
    bin.install "aws-rotate-key"
  end
end
