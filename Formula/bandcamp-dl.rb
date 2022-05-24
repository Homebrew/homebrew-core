class BandcampDl < Formula
  include Language::Python::Virtualenv

  desc "Simple python script to download Bandcamp albums"
  homepage "https://github.com/iheanyi/bandcamp-dl"
  url "https://files.pythonhosted.org/packages/cb/6f/08d0e2b1819327e375ebf67af0689727b2d49db7c0d11d4829552ea01ae4/bandcamp-downloader-0.0.13.tar.gz"
  sha256 "c7dbf489b2611406148a6ced25e5814b1fe666e3b3da6c744cfc3df2abe1b270"
  license "Unlicense"
  head "https://github.com/iheanyi/bandcamp-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a53d632875684037dc1f6489644b1648bbfc59549be526608330f3fe0d7cf1fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "691e8faae6d77f0550309769a75e695d90ab7b1d6a6eccd010a0232968406973"
    sha256 cellar: :any_skip_relocation, monterey:       "1c100cccd6b75c81614d5805016c1a6550214b4eac0ee241dbed36d39386ab70"
    sha256 cellar: :any_skip_relocation, big_sur:        "f33fea7b4d7a4c2fabba181bb50f67dc0f635c6a916e9be13fd933143bccfcde"
    sha256 cellar: :any_skip_relocation, catalina:       "b53ad5f672087b049517849a5546d52036dbfcab8126b0259f8014862b7fd42d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5562e050169ce44e6f21b6c36e3ada1b7613942a9f388926c095e3330e633f9"
  end

  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/e8/b0/cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7/beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c5/63/a8e4b0c24e8538cec5579edbb2df4ed1f980d5f186878905317139d83b61/certifi-2022.5.18.tar.gz"
    sha256 "6ae10321df3e464305a46e997da41ea56c1d311fb9ff1dd4e04d6f14653ec63a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "demjson3" do
    url "https://files.pythonhosted.org/packages/a1/09/4d20c71c1fbf091dc56315368d69a7d46cedf02002adf8e3c87b8e311f0a/demjson3-3.0.5.tar.gz"
    sha256 "ab9aabdd85695f3684fc296f39766a2730f6c8de81d23f7048073dfe2f616d80"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/3b/94/e2b1b3bad91d15526c7e38918795883cee18b93f6785ea8ecf13f8ffa01e/lxml-4.8.0.tar.gz"
    sha256 "f63f62fc60e6228a4ca9abae28228f35e1bd3ce675013d1dfb828688d50c6e23"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/e2/be/3ea39a8fd4ed3f9a25aae18a1bff2df7a610bca93c8ede7475e32d8b73a0/mock-4.0.3.tar.gz"
    sha256 "7d3fbbde18228f4ff2f1f119a45cdffa458b4c0dee32eb4d2bb2f82554bac7bc"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/f3/d9/2232a4cb9a98e2d2501f7e58d193bc49c956ef23756d7423ba1bd87e386d/mutagen-1.45.1.tar.gz"
    sha256 "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  resource "unicode-slugify" do
    url "https://files.pythonhosted.org/packages/ed/37/c82a28893c7bfd881c011cbebf777d2a61f129409d83775f835f70e02c20/unicode-slugify-0.1.5.tar.gz"
    sha256 "25f424258317e4cb41093e2953374b3af1f23097297664731cdb3ae46f6bd6c3"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/41/16/ee78864c2c2ba9bddba3978baa378f83270c8b7810eb7900f84e62a9ffac/Unidecode-1.3.4.tar.gz"
    sha256 "8e4352fb93d5a735c788110d2e7ac8e8031eb06ccbfe8d324ab71735015f9342"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"bandcamp-dl", "--artist=iamsleepless", "--album=rivulets"
    assert_predicate testpath/"iamsleepless/rivulets/01 - rivulets.mp3", :exist?
    system bin/"bandcamp-dl", "https://iamsleepless.bandcamp.com/track/under-the-glass-dome"
    assert_predicate testpath/"iamsleepless/under-the-glass-dome/Single - under-the-glass-dome.mp3", :exist?
  end
end
