class Notifiers < Formula
  include Language::Python::Virtualenv

  desc "The easy way to send notifications"
  homepage "https://pypi.org/project/notifiers/"
  url "https://files.pythonhosted.org/packages/4f/36/4c300f55949b9be84284d51253ae48d564dc2c4f2bffb94f26c8c1485f07/notifiers-1.2.1.tar.gz"
  sha256 "34625af405f4aa19293eaaefe145ccc92c6018ae9798f53a03a7fcc996e541aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "e863c98a0deef506c93b6947df3487570d3b6713968779de3971f8fb77c1517a" => :catalina
    sha256 "e38c86c0923aa29d53a38095ae1162c1e64b30077666d08ffee9a5278adc8567" => :mojave
    sha256 "991eb6cde6f98169be00a5ff9e9a6f5cc5d65e73e09d1a48e3c8ba3b5160cbea" => :high_sierra
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
