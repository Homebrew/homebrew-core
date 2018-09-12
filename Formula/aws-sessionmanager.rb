class AwsSessionmanager < Formula
  desc "Session Manager Plugin for the AWS CLI"
  homepage "https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with.html"
  url "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip"
  version "1.0.0.0"
  sha256 "a68e716f618937e6671b1f01b1a7c2b986457a21c0274426effba8383e15c042"

  depends_on "python"

  def install
    bin.install "bin/session-manager-plugin"
    prefix.install_metafiles
    prefix.install "VERSION"
  end

  test do
    system "#{bin}/session-manager-plugin"
  end
end
