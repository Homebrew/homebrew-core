class Lightsailctl < Formula
  desc "AWS CLI plugin for publishing images to AWS Lightsail container services"
  homepage "https://lightsail.aws.amazon.com/ls/docs/en_us/articles/amazon-lightsail-install-software"
  url "https://s3.us-west-2.amazonaws.com/lightsailctl/latest/darwin-amd64/lightsailctl"
  version "latest"
  license "Apache-2.0"

  depends_on "awscli" => ">2.1.1"

  def install
    chmod "+x", "lightsailctl"
    system "xattr", "-c", "lightsailctl"
    bin.install "lightsailctl"
  end

  test do
    assert_path_exist "#{bin}/lightsailctl"
  end
end
