class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/00/37/404f6114b07c1b08fc9c83cd99c5330cd0496c99b9bf9b11c579131a69ef/gimme%20aws%20creds-2.3.1.tar.gz"
  sha256 "6bf78df68353ba86c0490aee6439d4fdf394c400a81b7d788ad722c550842564"

  bottle do
    cellar :any
    sha256 "77404046e43851b502182b6ecdba3762aa517a1b7ed154a7c1904c200bac0b77" => :catalina
    sha256 "1e20ba32f42325c7eb88d25723222c82a199e899f6e3588accfba319ad4d8428" => :mojave
    sha256 "696ec3631236c529677440d0360a596b9dd8946226fb8f97e0851113415495f2" => :high_sierra
  end

  depends_on "python@3.8"

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
    assert_match "", config_file.read

    assert_match version.to_s, shell_output("#{bin}/gimme-aws-creds --version")
  end
end
