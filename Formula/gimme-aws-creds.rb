class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/be/01/ad8c22666aa8f805f2fd48083de2d2b29955c73e6fd1e1b651a0881c1d2c/gimme%20aws%20creds-2.2.0.tar.gz"
  sha256 "1b36df17f43c07826459a12ae26ca3792df6605bcd58f7b8180b654f5dd03318"

  bottle do
    cellar :any
    sha256 "0bdb742327fac0108150ed99a8cec5705f52c83d233dc284ac2c2588a40cdd51" => :catalina
    sha256 "f97c68d3bb41a8a4bf60222989d67467b3149503f2fa5d3c5300e91de58e4846" => :mojave
    sha256 "07f601983b1f852fe85d80726ba22f7844ebe4a96fcf61c37fcd35b6a64f8744" => :high_sierra
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "gimme-aws-creds"
    venv.pip_install_and_link buildpath
  end

  test do
    # Workaround gimme-aws-creds bug which runs action-configure twice when config file is missing.
    config_file = Pathname(".okta_aws_login_config")
    touch(config_file)

    output = pipe_output("#{bin}/gimme-aws-creds --action-configure 2>&1", "TESTPROFILE\nhttps://something.oktapreview.com\n\n\n\n\n\n\n\n\n\n\n")
    assert_match "Okta Configuration Profile Name", output
    assert_match "[TESTPROFILE]", config_file.read

    assert_match version.to_s, shell_output("#{bin}/gimme-aws-creds --version")
  end
end
