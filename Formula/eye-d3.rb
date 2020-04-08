class EyeD3 < Formula
  include Language::Python::Virtualenv

  desc "Work with ID3 metadata in .mp3 files"
  homepage "https://eyed3.nicfit.net/"
  url "https://eyed3.nicfit.net/releases/eyeD3-0.9.5.tar.gz"
  sha256 "faf5806197f2093e82c2830d41f2378f07b3a9da07a16fafb14fc6fbdebac50a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "df989613941c9c28f35b5efea82752fac9d0efeda871955ee833e688d0566a80" => :catalina
    sha256 "df989613941c9c28f35b5efea82752fac9d0efeda871955ee833e688d0566a80" => :mojave
    sha256 "df989613941c9c28f35b5efea82752fac9d0efeda871955ee833e688d0566a80" => :high_sierra
  end

  depends_on "python@3.8"

  # Looking for documentation? Please submit a PR to build some!
  # See https://github.com/Homebrew/homebrew/issues/32770 for previous attempt.

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b8/e2/a3a86a67c3fc8249ed305fc7b7d290ebe5e4d46ad45573884761ef4dea7b/certifi-2020.4.5.1.tar.gz"
    sha256 "51fcb31174be6e6664c5f69e3e1691a2d72a1a12e90f872cbdb1567eb47b6519"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/cd/94/8d9d6303f5ddcbf40959fc2b287479bd9a201ea9483373d9b0882ae7c3ad/deprecation-2.0.7.tar.gz"
    sha256 "c0392f676a6146f0238db5744d73e786a43510d54033f80994ef2f4c9df192ed"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/b8/1f/5c7999077c31db27cc9b0048a7aaddeb76f01276645546ae5c561880dd30/filetype-1.0.6.tar.gz"
    sha256 "99d2b923921cadbe6e451249091ca7156b4beaee6e741bd711a582d4dd2f2881"
  end

  resource "grako" do
    url "https://files.pythonhosted.org/packages/33/0d/6db911c7f6458974745c91c1e71841e347364798a5cc01e8149e84352c77/grako-3.99.9.zip"
    sha256 "fcc37309eab7cd0cbbb26cfd6a54303fbb80a00a58ab295d1e665bc69189c364"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/37/83e3f492eb52d771e2820e88105f605335553fe10422cba9d256faeb1702/packaging-20.3.tar.gz"
    sha256 "3c292b474fda1671ec57d46d739d072bfd495a4f51ad01a055121d81e952b7a3"
  end

  resource "pylast" do
    url "https://files.pythonhosted.org/packages/d5/6e/52cc82855010d6d9bdc75417e0c92b4b6ac2b071879faed790be712f564e/pylast-3.2.1.tar.gz"
    sha256 "3c984be04c9a22a884c3106a7f75749466d27c68870d6fb7e1f56b71becea7c0"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/16/8b/54a26c1031595e5edd0e616028b922d78d8ffba8bc775f0a4faeada846cc/ruamel.yaml-0.16.10.tar.gz"
    sha256 "099c644a778bf72ffa00524f78dd0b6476bca94a1da344130f4bf3381ce5b954"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/92/28/612085de3fae9f82d62d80255d9f4cf05b1b341db1e180adcf28c1bf748d/ruamel.yaml.clib-0.2.0.tar.gz"
    sha256 "b66832ea8077d9b3f6e311c4a53d06273db5dc2db6e8a908550f3c14d67e718c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/09/06/3bc5b100fe7e878d3dee8f807a4febff1a40c213d2783e3246edde1f3419/urllib3-1.25.8.tar.gz"
    sha256 "87716c2d2a7121198ebcb7ce7cccf6ce5e9ba539041cfbaeecfb641dc0bf6acc"
  end

  def install
    virtualenv_install_with_resources
    share.install "docs/plugins", "docs/cli.rst"
  end

  test do
    touch "temp.mp3"
    system "#{bin}/eyeD3", "-a", "HomebrewYo", "-n", "37", "temp.mp3"
  end
end
