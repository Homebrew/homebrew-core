class PassImport < Formula
  include Language::Python::Virtualenv

  desc "Pass extension for importing data from most existing password managers"
  homepage "https://github.com/roddhjav/pass-import"
  url "https://files.pythonhosted.org/packages/f1/69/1d763287f49eb2d43f14280a1af9f6c2aa54a306071a4723a9723a6fb613/pass-import-3.5.tar.gz"
  sha256 "e3e5ec38f58511904a82214f8a80780729dfe84628d7c5d6b1cedee20ff3fb23"
  license "GPL-3.0-or-later"
  revision 9
  head "https://github.com/roddhjav/pass-import.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e05e35a7cffcc047c2cd7c3fad599cf7a0c419b7d83645db51f785daf673859c"
    sha256 cellar: :any,                 arm64_sequoia: "9ae721ec82e772a31a34d13543bda6a6a6268f1206768ef4220781f68b7fc73e"
    sha256 cellar: :any,                 arm64_sonoma:  "ef101bca53c08111af4ad3557928900eaa9a0d8939a4fb4d8faa578db78070ef"
    sha256 cellar: :any,                 sonoma:        "2f060a3d41c5a88bf40207232dc9da0f4ecaeea6e428c45f86703ef888e2da91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bbd057bff2470696ac5ab9b63ffcbbedf814ab7f83fc80a4f39acc9ae3ab062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff6a55fecbc4d90b57b98e67d19712e9236e8c84f2130a41cc62b09c14e6a55d"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "pyaml" do
    url "https://files.pythonhosted.org/packages/38/fb/2b9590512a9d7763620d87171c7531d5295678ce96e57393614b91da8998/pyaml-26.2.1.tar.gz"
    sha256 "489dd82997235d4cfcf76a6287fce2f075487d77a6567c271e8d790583690c68"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/43/b8/7a707d60fea4c49094e40262cc0e2ca6c768cca21587e34d3f705afec47e/requests-2.34.0.tar.gz"
    sha256 "7d62fe92f50eb82c529b0916bb445afa1531a566fc8f35ffdc64446e771b856a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "zxcvbn" do
    url "https://files.pythonhosted.org/packages/ae/40/9366940b1484fd4e9423c8decbbf34a73bf52badb36281e082fe02b57aca/zxcvbn-4.5.0.tar.gz"
    sha256 "70392c0fff39459d7f55d0211151401e79e76fcc6e2c22b61add62900359c7c1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    importers = shell_output("#{bin}/pimport --list-importers")
    assert_match(/The \d+ supported password managers are:/, importers)

    exporters = shell_output("#{bin}/pimport --list-exporters")
    assert_match(/The \d+ supported exporter password managers are/, exporters)
  end
end
