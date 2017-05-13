class BandcampDl < Formula
  include Language::Python::Virtualenv

  desc "Simple python script to download Bandcamp albums"
  homepage "https://github.com/iheanyi/bandcamp-dl"
  url "https://github.com/iheanyi/bandcamp-dl/archive/v0.0.8-02.tar.gz"
  version "0.0.8-02"
  sha256 "c039104965cb67d5500931cf5beb65466931b58b576622d499d039db7a049320"
  head "https://github.com/iheanyi/bandcamp-dl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c62c906a7bc74ff5034b465c589534aa03f4009e90c51697eff12ac18c78d10" => :sierra
    sha256 "8a031a40409cb94da1c9d54c57a4d3b381826c0ba41b03ca78ca8eff332d7280" => :el_capitan
    sha256 "ca1ba49480478f7e8223440496006a78815d68d25b16126a4369b2bca857f3e9" => :yosemite
  end

  depends_on :python3

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/ba/64/410af95d27f2a8824112d17ed41ea7ce6d2cbc8a4832c2e548d3408fad0a/Unidecode-0.04.20.tar.gz"
    sha256 "ed4418b4b1b190487753f1cca6299e8076079258647284414e6d607d1f8a00e0"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/fa/8d/1d14391fdaed5abada4e0f63543fef49b8331a34ca60c88bd521bcf7f782/beautifulsoup4-4.6.0.tar.gz"
    sha256 "808b6ac932dccb0a4126558f7dfdcf41710dd44a4ef497a0bb59a77f9f078e89"
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

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/14/d5/51f49f345d4490a9a6a04677ab136f78e4e0c64ed142e48b4ed818c13c96/mutagen-1.37.tar.gz"
    sha256 "539553d3f1ffd890c74f64b819750aef0316933d162c09798c9e7eaf334ae760"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/1e/f0/9963f6ff9fb3861384be272c07522a9e85441ea5524f7fe15d07cadcae2a/pbr-3.0.0.tar.gz"
    sha256 "568f988af109114fbfa0525dcb6836b069838360d11732736ecc82e4c15d5c12"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/72/46/4abc3f5aaf7bf16a52206bb0c68677a26c216c1e6625c78c5aef695b5359/requests-2.14.2.tar.gz"
    sha256 "a274abba399a23e8713ffd2b5706535ae280ebe2b8069ee6a941cb089440d153"
  end

  resource "unicode-slugify" do
    url "https://files.pythonhosted.org/packages/8c/ba/1a05f61c7fd72df85ae4dc1c7967a3e5a4b6c61f016e794bc7f09b2597c0/unicode-slugify-0.1.3.tar.gz"
    sha256 "34cf3afefa6480efe705a4fc0eaeeaf7f49754aec322ba3e8b2f27dc1cbcf650"
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
