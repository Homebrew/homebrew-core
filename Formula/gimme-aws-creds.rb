class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/00/37/404f6114b07c1b08fc9c83cd99c5330cd0496c99b9bf9b11c579131a69ef/gimme%20aws%20creds-2.3.1.tar.gz"
  sha256 "6bf78df68353ba86c0490aee6439d4fdf394c400a81b7d788ad722c550842564"
  revision 1

  bottle do
    cellar :any
    sha256 "6817c604e6980c47652d33a84a79f930d4f9c6abb55ccf51730933ed0346d451" => :catalina
    sha256 "f7f0c28acf2733c1bf4b43b7e68133f7efce924af1f1c658ca22216748d675b1" => :mojave
    sha256 "069697429d780e0f076215e7ddb8e7324fc8e538601cb99847e05daff073da85" => :high_sierra
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

    output = pipe_output("#{bin}/gimme-aws-creds --action-configure 2>&1", "TESTPROFILE\nhttps://something.oktapreview.com\n\n\n\n\n\n\n\n\n\n\n")
    assert_match "Okta Configuration Profile Name", output
    assert_match "", config_file.read

    assert_match version.to_s, shell_output("#{bin}/gimme-aws-creds --version")
  end
end
