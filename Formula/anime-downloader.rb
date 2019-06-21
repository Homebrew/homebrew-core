class AnimeDownloader < Formula
  include Language::Python::Virtualenv

  desc "Simple but powerful anime downloader and streamer"
  homepage "https://github.com/vn-ki/anime-downloader"
  url "https://github.com/vn-ki/anime-downloader/archive/3.6.3.tar.gz"
  sha256 "5908263efebd535089b9a856ae3855171a30accec49b827ff4e71245d5115757"
  head "https://github.com/vn-ki/anime-downloader.git"

  depends_on "node"
  depends_on "python"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/80/f2/f6aca7f1b209bb9a7ef069d68813b091c8c3620642b568dac4eb0e507748/beautifulsoup4-4.7.1.tar.gz"
    sha256 "945065979fb8529dd2f37dbb58f00b661bdbcbebf954f93b32fdf5263ef35348"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/b8/d1ea38513c22e8c906275d135818fee16ad8495985956a9b7e2bb21942a1/certifi-2019.3.9.tar.gz"
    sha256 "b26104d6835d1f5e49452a26eb2ff87fe7090b89dfcaee5ea2212697e1e1d7ae"
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

  resource "fuzzywuzzy" do
    url "https://files.pythonhosted.org/packages/81/54/586e9f34401dc7f5248589765bb67d49b837e2f309f25a33e82e896cba0a/fuzzywuzzy-0.17.0.tar.gz"
    sha256 "6f49de47db00e1c71d40ad16da42284ac357936fa9b66bea1df63fed07122d62"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/fb/9e/2e236603b058daa6820193d4d95f4dcfbbbd0d3c709bec8c6ef1b1902501/soupsieve-1.9.1.tar.gz"
    sha256 "b20eff5e564529711544066d7dc0f7661df41232ae263619dede5059799cdfca"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/3c/1bb7ef6c435dea026f06ed9f3ba16aa93f9f4f5d3857a51a35dfa00882f1/urllib3-1.24.3.tar.gz"
    sha256 "2393a695cd12afedd0dcb26fe5d50d0cf248e5a66f75dbd89a3d4eb333a61af4"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install "beautifulsoup4"
    venv.pip_install "certifi"
    venv.pip_install "cfscrape"
    venv.pip_install "chardet"
    venv.pip_install "click"
    venv.pip_install "fuzzywuzzy"
    venv.pip_install "idna"
    venv.pip_install "requests"
    venv.pip_install "soupsieve"
    venv.pip_install "urllib3"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "anime, version 3.6.3", shell_output("#{bin}/anime --version")
    system "sh", "-c", "echo ^C | anime dl 'Kaguya-sama' --provider animepahe | head -1 > out"
    assert_match " 1: Kaguya-sama wa Kokurasetai: Tensai-tachi", (testpath/"out").read
  end
end
