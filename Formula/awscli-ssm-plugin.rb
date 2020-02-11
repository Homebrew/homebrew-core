class AwscliSsmPlugin < Formula
  include Language::Python::Virtualenv

  desc "Session Manager plugin for Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/systems-manager/"
  url "https://s3.amazonaws.com/session-manager-downloads/plugin/1.1.54.0/mac/sessionmanager-bundle.zip"
  version "1.1.54.0"
  sha256 "d9b558193370b2ecc0ddba001b6ee974b14b60d4d247851706e26a9811f15349"

  depends_on "awscli"

  def install
    virtualenv_create(libexec, "python3")
    system libexec/"bin/python3 #{buildpath}/install -i #{prefix}"
  end

  test do
    assert_match "The Session Manager plugin was installed successfully. Use the AWS CLI to start a session.", shell_output("#{bin}/session-manager-plugin")
  end
end
