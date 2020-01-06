class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/a2/e7/881b9859655f0d21305da963ce24954a4f19b76473abd4c23e997497888e/gimme%20aws%20creds-2.2.1.tar.gz"
  sha256 "3e08271a456f5c73e573e13c90527c81c6497fcf69ba83e2907c3ce5edf22b5a"

  bottle do
    cellar :any
    sha256 "016589b6320a71cb2dd9b1b1a0db93593b52e809982d93743ba08eda5781fef5" => :catalina
    sha256 "9818c0212ed7544b223c27d9a8a9dba09c8760ecebf4acc3e9c29e884049eb98" => :mojave
    sha256 "5860b4d70155504c94c4881c566b63eee754ed63131abe130826f112bf4d512e" => :high_sierra
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
