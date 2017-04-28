class BandcampDl < Formula
  include Language::Python::Virtualenv

  desc "Simple python script to download Bandcamp albums"
  homepage "https://github.com/iheanyi/bandcamp-dl"
  url "https://github.com/iheanyi/bandcamp-dl/archive/v0.0.7-09.tar.gz"
  version "0.0.7-09"
  sha256 "9e2268295ca6ef6e6991569726d1a912a110e7a87079eeef269477a5adafb5b2"
  head "https://github.com/iheanyi/bandcamp-dl.git"

  depends_on :python3

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/9b/a5/c6fa2d08e6c671103f9508816588e0fb9cec40444e8e72993f3d4c325936/beautifulsoup4-4.5.3.tar.gz"
    sha256 "b21ca09366fa596043578fd4188b052b46634d22059e68dd0077d9ee77e08a3e"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/91/05/28f23094cdf1410fb03533f0d71e6b4aad3c504100e83b8cea6fc899552c/chardet-3.0.2.tar.gz"
    sha256 "4f7832e7c583348a9eddd927ee8514b3bf717c061f57b21dbe7697211454d9bb"
  end

  resource "demjson" do
    url "https://files.pythonhosted.org/packages/96/67/6db789e2533158963d4af689f961b644ddd9200615b8ce92d6cad695c65a/demjson-2.2.4.tar.gz"
    sha256 "31de2038a0fdd9c4c11f8bf3b13fe77bc2a128307f965c8d5fb4dc6d6f6beb79"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/14/d5/51f49f345d4490a9a6a04677ab136f78e4e0c64ed142e48b4ed818c13c96/mutagen-1.37.tar.gz"
    sha256 "539553d3f1ffd890c74f64b819750aef0316933d162c09798c9e7eaf334ae760"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/16/09/37b69de7c924d318e51ece1c4ceb679bf93be9d05973bb30c35babd596e2/requests-2.13.0.tar.gz"
    sha256 "5722cd09762faa01276230270ff16af7acf7c5c45d623868d9ba116f15791ce8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "unicode-slugify" do
    url "https://files.pythonhosted.org/packages/8c/ba/1a05f61c7fd72df85ae4dc1c7967a3e5a4b6c61f016e794bc7f09b2597c0/unicode-slugify-0.1.3.tar.gz"
    sha256 "34cf3afefa6480efe705a4fc0eaeeaf7f49754aec322ba3e8b2f27dc1cbcf650"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/ba/64/410af95d27f2a8824112d17ed41ea7ce6d2cbc8a4832c2e548d3408fad0a/Unidecode-0.04.20.tar.gz"
    sha256 "ed4418b4b1b190487753f1cca6299e8076079258647284414e6d607d1f8a00e0"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/9b/cf/6c6f843ffc13aee42c5412c49e7aff7e860d006261dcafb5a5512fa27cd6/pbr-2.1.0.tar.gz"
    sha256 "f71359a7e2de2f5ea1eceea7c1e3222f2560ee48e21eef6f96957bb5c2ebb94a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/bandcamp-dl", "--artist=iamsleepless", "--album=rivulets"
    assert File.exist?("iamsleepless/rivulets/01 - rivulets.mp3")
    system "#{bin}/bandcamp-dl", "https://iamsleepless.bandcamp.com/track/under-the-glass-dome"
    assert File.exist?("iamsleepless/under-the-glass-dome/Single - under-the-glass-dome.mp3")
  end
end
