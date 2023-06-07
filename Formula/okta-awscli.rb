class OktaAwscli < Formula
  include Language::Python::Virtualenv

  desc "Okta authentication for awscli"
  homepage "https://github.com/okta-awscli/okta-awscli"
  url "https://files.pythonhosted.org/packages/aa/d3/1c954881dea1d1ceccbf54353fb26c4487a8c4702dd415ac44744e306c97/okta-awscli-0.5.4.tar.gz"
  sha256 "509921a38dedc6fa1424f06e5bb94a5bb359463912c45218abdf6095b3aac821"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25516d5b5d65bd1bba979b11ec324f02b9fb15d9ece07ddcc316e4ee093f3e3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9acb53e831e376f62c8beb0506ed4be7da288db83ae068cf4c9ee649344afa4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6000175b6b0ea35e8739edd1455afc1b088c90bb5fff2f9c9e474da53d7618d9"
    sha256 cellar: :any_skip_relocation, ventura:        "3514597c084a2c790b7ac9b880d3cfd8e0235034640e7e150492aee49d8c5ab9"
    sha256 cellar: :any_skip_relocation, monterey:       "1eb4044aad333a7997bad8fbe02cfdec7ccf72bd6d77bde100eb26abee0a45c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4574145bbe6b765ac7fe4d471a17afc56e8f0efb6f624323c145a2ad109a1789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10cd8efd42292bf90554bb5fc619744f15c9a760d4fc1b00ae451a8cad401f5a"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/7f/17/595fa7f8a7782e5b76cee89b12cb44c767fc439a0a4a5177e45087e49f96/boto3-1.26.139.tar.gz"
    sha256 "fe19d287bc8ede385e1b9136f135ee8f93eab81404ad1445b1a70cabfe3f7087"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/85/e0/32053bd0dc53a495013fb76d1cdd9b03d9da8dde9bba14dae6c36785c7ac/botocore-1.29.139.tar.gz"
    sha256 "acc62710bdf11e47f4f26fb290a9082ff00377d7e93a16e1f080f9c789898114"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/10/ed/7e8b97591f6f456174139ec089c769f89a94a1a4025fe967691de971f314/bs4-0.0.1.tar.gz"
    sha256 "36ecea1fd7cc5c0c6e4a1ff075df26d50da647b75376626cc186e2212886dd3a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/4b/c0/3a47084aca7a940ed1334f89ed2e67bcb42168c4f40c486e267fe71e7aa0/configparser-5.3.0.tar.gz"
    sha256 "8be267824b541c09b08db124917f48ab525a6c3e837011f3130781a224c57090"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
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
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/9e/780779233a615777fbdf75a4dee2af7a345f4bf74b42d4a5f836800b9d91/soupsieve-2.4.1.tar.gz"
    sha256 "89d12b2d5dfcd2c9e8c22326da9d9aa9cb3dfab0a83a024f05704076ee8d35ea"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/95/14/ed0af6865d378cfc3c504aed0d278a890cbefb2f1934bf2dbe92ecf9d6b1/validators-0.20.0.tar.gz"
    sha256 "24148ce4e64100a2d5e267233e23e7afeb55316b47d30faae7eb6e7292bc226a"
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
