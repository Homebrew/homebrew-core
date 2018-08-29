class Kbdgen < Formula
  include Language::Python::Virtualenv

  desc "Generate keyboards and keyboard layouts for various operating systems"
  homepage "https://divvun.github.io/kbdgen/"
  url "https://github.com/divvun/kbdgen/archive/b830205.tar.gz"
  version "0.5.0"
  sha256 "da5c3ca2bacae518d5157b053ee91f43a025fbba13bbbf284b8c1b9f74bde829"

  depends_on "imagemagick"
  depends_on "python"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ca/63/139b710671c1655aed3b20c1e6776118c62e9f9311152f4c6031e12a0554/lxml-4.2.4.tar.gz"
    sha256 "e2afbe403090f5893e254958d02875e0732975e73c4c0cdd33c1f009a61963ca"
  end

  resource "lcid" do
    url "https://files.pythonhosted.org/packages/61/d9/4658e0a69d7254e46809b8a88b17b4b0e4ce2ca5634f8cf2bab0cf330c92/lcid-1.0.1.tar.gz"
    sha256 "f2295031d9e685c14af57fe4a5f65ab2eb0656b3ecc19b9350a916290c7b9db9"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e1/0f/f8d5e939184547b3bdc6128551b831a62832713aa98c2ccdf8c47ecc7f17/certifi-2018.8.24.tar.gz"
    sha256 "376690d6f16d32f9d1fe8932551d80b23e9d393a8578c5633a2ed39a64861638"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/54/1f/782a5734931ddf2e1494e4cd615a51ff98e1879cbe9eecbdfeaf09aa75e9/requests-2.19.1.tar.gz"
    sha256 "ec22d826a36ed72a7358ff3fe56cbd4ba69dd7a6718ffd450ff0e9df7a47ce6a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/3c/d2/dc5471622bd200db1cd9319e02e71bc655e9ea27b8e0ce65fc69de0dac15/urllib3-1.23.tar.gz"
    sha256 "a68ac5e15e76e7e5dd2b8f94007233e01effe3e50e8daddf69acfd81cb686baf"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/8c/e0/e512e4ac6d091fc990bbe13f9e0378f34cf6eecd1c6c268c9e598dcf5bb9/humanize-0.5.1.tar.gz"
    sha256 "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19"
  end

  resource "pycountry" do
    url "https://files.pythonhosted.org/packages/9e/a0/1ecb5593a5da69a44ae8fc5b8b831a08b6801f500aea1341ee3224f29ebb/pycountry-18.5.26.tar.gz"
    sha256 "7f2aa2529c60f6575af3cd644688b201b97016822ce0ce1c4bcc0f7d08900997"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/kbdgen", "--version"
    system "#{bin}/cldr2kbdgen", "-h"
    system "#{bin}/kbdgen2cldr", "-h"
  end
end
