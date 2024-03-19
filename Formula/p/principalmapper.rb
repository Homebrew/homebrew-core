class Principalmapper < Formula
  include Language::Python::Virtualenv

  desc "Quickly evaluate IAM permissions in AWS"
  homepage "https://github.com/nccgroup/PMapper"
  url "https://files.pythonhosted.org/packages/3f/8c/3d2efe475e9244bd45e3a776ea8207f34a9bb15caaa02f6c95e473b2ada2/principalmapper-1.1.5.tar.gz"
  sha256 "04cb9dcff0cc512df4714b3c4ea63a261001f271f95c8a453b2805290c57bbc2"
  license "AGPL-3.0-or-later"
  revision 3

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39c91c47b0168bd27ed5e72514791d3539143883755ab101fabaae6398dad4c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98e0059909b81c8db7504ed1ab368829353abd208d767c29be8105f151701a42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "912f3b13b00b1005eedd854ce36389d3a06c216cb0d828b104cba1c806dd7f6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0627e606a615ce55918f6707d7bf1471f6d95c83917e0d6a25056cb77c68b42c"
    sha256 cellar: :any_skip_relocation, ventura:        "c4ba43acd5d1961d66c6592f91e043c9337c8963abef08669705f6c53dec7d0b"
    sha256 cellar: :any_skip_relocation, monterey:       "0d9aad2145eff7ac4afddc62276f9d38d9ab06cc4c264794f5870c6981506701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6d317dd3f7b54fcc7ebd7d704a217b0c89c5e92e6e5b7a923cdcbf3d183ae9b"
  end

  depends_on "python@3.12"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/93/cf/8c9516f6b1fb859e7fcb7413942b51573b54113307a92db46a44497a3b96/botocore-1.34.47.tar.gz"
    sha256 "29f1d6659602c5d79749eca7430857f7a48dd02e597d0ea4a95a83c47847993e"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/d7/2f/482fcbc389e180e7f8d7e7cb06bc5a7c37be6c57939dfb950951d97f2722/pydot-2.0.0.tar.gz"
    sha256 "60246af215123fa062f21cd791be67dda23a6f280df09f68919e637a1e4f3235"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  # Support Python 3.10, remove on next release
  patch do
    url "https://github.com/nccgroup/PMapper/commit/88bad89bd84a20a264165514363e52a84d39e8d7.patch?full_index=1"
    sha256 "9c731e2613095ea5098eda7141ae854fceec3fc8477a7a7e3202ed6c751e68dc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Account IDs:\n---", shell_output("#{bin}/pmapper graph list").strip
  end
end
