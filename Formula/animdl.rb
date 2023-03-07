class Animdl < Formula
  include Language::Python::Virtualenv

  desc "Anime downloader and streamer"
  homepage "https://github.com/justfoolingaround/animdl"
  url "https://files.pythonhosted.org/packages/01/7b/47c107f7311e622e4b679c7e90bd97d3d45532fc997d20b632d692175484/animdl-1.7.7.tar.gz"
  sha256 "64a78a9c11b544a8f470f5ac1c57e39247d3e50735a6d33a277dd1cc27229c37"
  license "GPL-3.0-only"
  head "https://github.com/justfoolingaround/animdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e09b513b85fcf3c98dfb5d669a4ca5e1bb7ebfb7b6f4cb7e42a32460cef83e20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a56bd32fe864aa1b639fa730ecfdae78fb55eeae493bcf35dfdb9f9432250cc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "557d840d18aafed892513c36d700125777d157bc40a0861f6a0133eeca8f575b"
    sha256 cellar: :any_skip_relocation, ventura:        "dffaaf17cb687b085fd6f4a287b8b04782fb8df57b020a9a7eb75f75fba42bbb"
    sha256 cellar: :any_skip_relocation, monterey:       "3f8b15f16ddc494259123f3033d9c452b760f69ed256843cb1b4b0d0a55bc88a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b376db6cdcd1baf6c72e07b69cffbc012b6b5998affa27d3d7572f830b47eaf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22a99cc76a033c8282ff978c140b02494a3b45a1fb595eae7ce4c60f90c9b1bc"
  end

  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "pyyaml"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "anchor-kr" do
    url "https://files.pythonhosted.org/packages/dd/46/c96feb94c9101ca57b9d612b6510b06da31d31321e5c54fca6cb4a6a0adf/anchor-kr-0.1.3.tar.gz"
    sha256 "0fc055b6fd359bd20225dc4c39f721535af3245b068724db09c62a0f95ec4bbf"
  end

  resource "anitopy" do
    url "https://files.pythonhosted.org/packages/d3/8b/3da3f8ba73b8e4e5325a9ecbd6780f4dc9f41c98cc1c6a897800c4f85979/anitopy-2.1.1.tar.gz"
    sha256 "515b97cd78917ee406313f4eb53bdc75e8a573e6ad5252ffd355c96a06988e26"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/8b/94/6928d4345f2bc1beecbff03325cad43d320717f51ab74ab5a571324f4f5a/anyio-3.6.2.tar.gz"
    sha256 "25ea0d673ae30af41a0c442f81cf3b38c7e79fdc7b60335a4c14e05eb0947421"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
  end

  resource "comtypes" do
    url "https://files.pythonhosted.org/packages/e9/c3/f1b3d86f210e42c3103d4e6c22b9775747d78c337acd3f7f7ab615f5c3e2/comtypes-1.1.14.zip"
    sha256 "5d7caf6d3a86d51ddfc53e4548cae2dceee1b46672f8bd59679711dd01a934f2"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/70/54/37630f6eb2c214cdee2ae56b7287394c8aa2f3bafb8b4eb8c3791aae7a14/cssselect-1.1.0.tar.gz"
    sha256 "f95f8dedd925fd8f54edb3d2dfb44c190d9d18512377d3c1e2388d16126879bc"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/61/42/5c456b02816845d163fab0f32936b6a5b649f3f915beff6f819f4f6c90b2/httpcore-0.16.3.tar.gz"
    sha256 "c5d6f04e2fc530f39e0c077e6a30caa53f1451096120f1f38b954afd0b17c0cb"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/f5/50/04d5e8ee398a10c767a341a25f59ff8711ae3adf0143c7f8b45fc560d72d/httpx-0.23.3.tar.gz"
    sha256 "9818458eb565bb54898ccb9b8b251a28785dd4a55afbc23d0eb410754fe7d0f9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/23/bda4e9881090f0f5e33e2efe89aacfa0668eb6e1ab2de28591e2912d78d4/lxml-4.9.0.tar.gz"
    sha256 "520461c36727268a989790aef08884347cd41f2d8ae855489ccf40b50321d8d7"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/6b/f7/c240d7654ddd2d2f3f328d8468d4f1f876865f6b9038b146bec0a6737c65/packaging-22.0.tar.gz"
    sha256 "2198ec20bd4c017b8f9717e00f0c8714076fc2fd93816750ab48e2c41de2cfd3"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/b4/1c/89b38e431c20d6b2389ed8b3926c2ab72f58944733ba029354c6d9f69129/pkginfo-1.9.6.tar.gz"
    sha256 "8fd5896e8718a4372f0ea9cc9d96f6417c9b986e23a4d116dda26b62cc29d046"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/24/40/e249ac3845a2333ce50f1bb02299ffb766babdfe80ca9d31e0158ad06afd/pycryptodomex-3.14.1.tar.gz"
    sha256 "2ce76ed0081fd6ac8c74edc75b9d14eca2064173af79843c24fa62573263c1f2"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/79/30/5b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8/rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/5e/0e/ef0a49be56dbc4052a086888cd2490e15fcc95b0eda79e9d0e737b1ab93d/rich-13.3.2.tar.gz"
    sha256 "91954fe80cfb7985727a467ca98a7618e5dd15178cc2da10f553b36a93859001"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/e3/c1/b3e42d5b659ca598508e2a9ef315d5eef0a970f874ef9d3b38d4578765bd/tqdm-4.62.3.tar.gz"
    sha256 "d359de7217506c9851b7869f3708d8ee53ed70a1b8edbba4dbcb47442592920d"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/c4/1e/1b204050c601d5cd82b45d5c8f439cb6f744a2ce0c0a6f83be0ddf0dc7b2/yarl-1.8.2.tar.gz"
    sha256 "49d43402c6e3013ad0978602bf6bf5328535c48d192304b91b97a3c6790b1562"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"config.yml"
    test_config.write <<~EOS
      default_provider: animixplay
    EOS

    assert_match "One Piece Film", shell_output("#{bin}/animdl search \"one piece\" 2>&1")
    assert_match "animdl, version #{version}", shell_output("#{bin}/animdl --version")
  end
end
