class Notifiers < Formula
  include Language::Python::Virtualenv

  desc "The easy way to send notifications"
  homepage "https://pypi.org/project/notifiers/"
  url "https://files.pythonhosted.org/packages/4f/36/4c300f55949b9be84284d51253ae48d564dc2c4f2bffb94f26c8c1485f07/notifiers-1.2.1.tar.gz"
  sha256 "34625af405f4aa19293eaaefe145ccc92c6018ae9798f53a03a7fcc996e541aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "a63f035ec98db41ef133ed46ce5b18ab67f803ef0cb72addf8bf5e5b1057dceb" => :catalina
    sha256 "c85158b60cfeccb3a3b99ad348b53ffd4fa3aed5d6edefce4315456a3ef762ea" => :mojave
    sha256 "a3b4bad55ba728a3103672697fbffc026126771deb35b6922ca2b01bc977cfc9" => :high_sierra
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "notifiers"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "notifiers", shell_output("#{bin}/notifiers --help")
  end
end
