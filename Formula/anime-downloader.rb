class AnimeDownloader < Formula
  include Language::Python::Virtualenv

  desc "Download your favourite anime"
  homepage "https://github.com/vn-ki/anime-downloader"
  url "https://github.com/vn-ki/anime-downloader/archive/4.0.1.tar.gz"
  sha256 "19656b9d5cb8d1a663f32174ac1ab528eec5b0341e7008114686294c67b1bcdb"
  head "https://github.com/vn-ki/anime-downloader.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00357390e1ed8167d7dc984ffad8cded15a2fde732e53a562d11c15d5602ead5" => :catalina
    sha256 "726a87a5561af3e978593c781b612e12cb1f01086fb91f277d64de0b053bfe0a" => :mojave
    sha256 "70709fb3bc5d132f584fcf47527749c2bae3fc05ab14795d6818d46e2cc2268e" => :high_sierra
  end

  depends_on "aria2"
  depends_on "node"
  depends_on "python"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/80/f2/f6aca7f1b209bb9a7ef069d68813b091c8c3620642b568dac4eb0e507748/beautifulsoup4-4.7.1.tar.gz"
    sha256 "945065979fb8529dd2f37dbb58f00b661bdbcbebf954f93b32fdf5263ef35348"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/62/85/7585750fd65599e88df0fed59c74f5075d4ea2fe611deceb95dd1c2fb25b/certifi-2019.9.11.tar.gz"
    sha256 "e4f3620cfea4f83eedc95b24abd9cd56f3c4b146dd0177e83a21b4eb49e21e50"
  end

  resource "cfscrape" do
    url "https://files.pythonhosted.org/packages/6c/0b/ea6730d075cabe49c1c46d330392c81ab53f09e1a196d79f50c83c000522/cfscrape-2.0.7.tar.gz"
    sha256 "386873257c79280552901ecc2544b185daecf9ef27c126c542daa94b6fea09bf"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/63/09/1da37a51b232eaf9707919123b2413662e95edd50bace5353a548910eb9d/coloredlogs-10.0.tar.gz"
    sha256 "b869a2dda3fa88154b9dd850e27828d8755bfab5a838a1c97fbc850c6e377c36"
  end

  resource "fuzzywuzzy" do
    url "https://files.pythonhosted.org/packages/81/54/586e9f34401dc7f5248589765bb67d49b837e2f309f25a33e82e896cba0a/fuzzywuzzy-0.17.0.tar.gz"
    sha256 "6f49de47db00e1c71d40ad16da42284ac357936fa9b66bea1df63fed07122d62"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/26/71/e7daf57e819a70228568ff5395fdbc4de81b63067b93167e07825fcf0bcf/humanfriendly-4.18.tar.gz"
    sha256 "33ee8ceb63f1db61cce8b5c800c531e1a61023ac5488ccde2ba574a85be00a85"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/e2/7b/12f76a8bd427ebc54f24a0df6fd776fda48087d6a9a32ae0dbc3341dac3f/pycryptodome-3.8.2.tar.gz"
    sha256 "5bc40f8aa7ba8ca7f833ad2477b9d84e1bfd2630b22a46d9bbd221982f8c3ac0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/0c/d4/bdc22aad6979ceeea2638297f213108aeb5e25c7b103fa02e4acbe43992e/requests-cache-0.5.2.tar.gz"
    sha256 "813023269686045f8e01e2289cc1e7e9ae5ab22ddd1e2849a9093ab3ab7270eb"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/fb/9e/2e236603b058daa6820193d4d95f4dcfbbbd0d3c709bec8c6ef1b1902501/soupsieve-1.9.1.tar.gz"
    sha256 "b20eff5e564529711544066d7dc0f7661df41232ae263619dede5059799cdfca"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/66/d4/977fdd5186b7cdbb7c43a7aac7c5e4e0337a84cb802e154616f3cfc84563/tabulate-0.8.5.tar.gz"
    sha256 "d0097023658d4dea848d6ae73af84532d1e86617ac0925d1adf1dd903985dac3"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ff/44/29655168da441dff66de03952880c6e2d17b252836ff1aa4421fba556424/urllib3-1.25.6.tar.gz"
    sha256 "9a107b99a5393caf59c7aa3c1249c16e6879447533d0887f4336dde834c7be86"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install "beautifulsoup4"
    venv.pip_install "certifi"
    venv.pip_install "cfscrape"
    venv.pip_install "chardet"
    venv.pip_install "Click"
    venv.pip_install "coloredlogs"
    venv.pip_install "fuzzywuzzy"
    venv.pip_install "humanfriendly"
    venv.pip_install "idna"
    venv.pip_install "pycryptodome"
    venv.pip_install "requests"
    venv.pip_install "requests-cache"
    venv.pip_install "soupsieve"
    venv.pip_install "tabulate"
    venv.pip_install "urllib3"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "anime, version 4.0.1", shell_output("#{bin}/anime --version")
    system "sh", "-c", "echo 1 | #{bin}/anime watch -n Kaguya-sama --provider kissanime; echo 1 | #{bin}/anime watch -l | grep 0/12 > out"
    assert_match "    1 | Kaguya-sama: Love is War            |    0/12  |", (testpath/"out").read
    system "sh", "-c", "echo y | anime watch -r Kaguya-sama"
  end
end
