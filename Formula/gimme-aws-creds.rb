class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/e2/a7/53d5f021a1b41a680d5c558c683e37e3000085c1a4132695e3378e4b477d/gimme%20aws%20creds-2.3.3.tar.gz"
  sha256 "b7bc10cd09faf995e44063bb6125b910ee85cf2f3e95ddb2908afade4bbd3973"

  bottle do
    cellar :any
    sha256 "39c425c5154301eaa51798245adcd223abee150249b09d4da49fa655b3d60119" => :catalina
    sha256 "5789360170f0ae9e5dc213c19483facb08b028cf1d8794d04dda847650758506" => :mojave
    sha256 "3dede56e3653d34088e14852ca7ed76be11c5639b801cbb0f70597c6c4b5772e" => :high_sierra
  end

  depends_on "python@3.8"

  uses_from_macos "libffi"

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

    assert_match "Okta Configuration Profile Name",
      pipe_output("#{bin}/gimme-aws-creds --action-configure 2>&1",
                  "TESTPROFILE\nhttps://something.oktapreview.com\n\n\n\n\n\n\n\n\n\n\n")
    assert_match "", config_file.read

    assert_match version.to_s, shell_output("#{bin}/gimme-aws-creds --version")
  end
end
