class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/00/37/404f6114b07c1b08fc9c83cd99c5330cd0496c99b9bf9b11c579131a69ef/gimme%20aws%20creds-2.3.1.tar.gz"
  sha256 "6bf78df68353ba86c0490aee6439d4fdf394c400a81b7d788ad722c550842564"
  revision 1

  bottle do
    cellar :any
    sha256 "c9e13bca884634326430de7d4695cab7bd02521fd0ec3f8bb8e69377df52bfdf" => :catalina
    sha256 "6cfa1c0c00adbe19a5dff9fca00f900b1b781d04532a48430036cf9221adf743" => :mojave
    sha256 "1ccccf741140716020eef7ecb3cf003eedacda58e0d7edbddf98f7d3678f2dd1" => :high_sierra
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
