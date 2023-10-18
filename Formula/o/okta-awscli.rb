class OktaAwscli < Formula
  include Language::Python::Virtualenv

  desc "Okta authentication for awscli"
  homepage "https://github.com/okta-awscli/okta-awscli"
  url "https://files.pythonhosted.org/packages/aa/d3/1c954881dea1d1ceccbf54353fb26c4487a8c4702dd415ac44744e306c97/okta-awscli-0.5.4.tar.gz"
  sha256 "509921a38dedc6fa1424f06e5bb94a5bb359463912c45218abdf6095b3aac821"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "699d84243902ad445497970a6e1752ff8dcc23ab93f53230d6c35c42c31d91e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7be9111236d535a5ccc967f0ab4793bd973ced2a3082877e0ef624a95ed5219b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2767c559fbe6a9bc9847f8051b36f6cb94cb76d8c022cf165f54c44eab38abcd"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a948e9abf4b6f52cbc9f8fdea37ec930fa9c8dcabbab904d7c11c656f4ff8c3"
    sha256 cellar: :any_skip_relocation, ventura:        "ed00b3909653699bba767736c201a6561c27766e14fb5937c89ff05d6c96be31"
    sha256 cellar: :any_skip_relocation, monterey:       "4b6d0016f1e0f1f5d81cb0aa3d2c11b7a0a77602f98c8654435f05b50d7eefe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "699f2a007dfc16e01efd94776b900e8ad7c1598e7f0bc72993a597de6c7e5c27"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python@3.12"
  depends_on "six"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/08/93/0f614264bca69210ac6b0ae06bc112a9569a0b849499e6a7884b670d272a/boto3-1.28.63.tar.gz"
    sha256 "94218aba2feb5b404b665b8d76c172dc654f79b4c5fa0e9e92459c098da87bf4"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/a6/4f/4c2b7d96dd50aed47db6cccf6c1c089853f6474e1d1da5c5aa320d7d4157/botocore-1.31.63.tar.gz"
    sha256 "6e582c811ea74f25bdb490ac372b2645de4a60286b42ddd8c69f3b6df82b6b12"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/10/ed/7e8b97591f6f456174139ec089c769f89a94a1a4025fe967691de971f314/bs4-0.0.1.tar.gz"
    sha256 "36ecea1fd7cc5c0c6e4a1ff075df26d50da647b75376626cc186e2212886dd3a"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/0b/65/bad3eb64f30657ee9fa2e00e80b3ad42037db5eb534fadd15a94a11fe979/configparser-6.0.0.tar.gz"
    sha256 "ec914ab1e56c672de1f5c3483964e68f71b34e457904b7b76e06b922aec067a8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/9b/21/40a249498eee5a244a017582c06c0af01851179e2617928063a3d628bc8f/validators-0.22.0.tar.gz"
    sha256 "77b2689b172eeeb600d9605ab86194641670cdb73b60afd577142a9397873370"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/okta-awscli 2>&1", 1)
      ERROR - The app-link is missing. Will try to retrieve it from Okta
      ERROR - No profile found. Please define a default profile, or specify a named profile using `--okta-profile`
    EOS
  end
end
