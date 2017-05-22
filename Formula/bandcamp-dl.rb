class BandcampDl < Formula
  include Language::Python::Virtualenv

  desc "Simple python script to download Bandcamp albums"
  homepage "https://github.com/iheanyi/bandcamp-dl"
  url "https://github.com/iheanyi/bandcamp-dl/archive/v0.0.8-04.tar.gz"
  version "0.0.8-04"
  sha256 "acb8d54614b3e89c54fd6be8621759110b04e3462c087eb4eb827b8c4a31fd21"
  head "https://github.com/iheanyi/bandcamp-dl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "773833ac27e8f48ec18ef725b24cc3e765d8f45e0dc2031eae6ee094c86011de" => :sierra
    sha256 "202154dec6f2e605e2d317a6588dec984c1c3a324db4dd3be70ed9a590dba839" => :el_capitan
    sha256 "574c6c3c48a77ce11b2fd3e6fa9fecf83a3db09d729a1057074f7f7087064abe" => :yosemite
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
    url "https://files.pythonhosted.org/packages/fc/f9/3963ae8e196ceb4a09e0d7906f511fdf62a631f05d9288dc4905a93a1f52/chardet-3.0.3.tar.gz"
    sha256 "77df6d712a6037ed6f247ad1dd67faca506f64bc1295d43533e9212a101f28cb"
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
    url "https://files.pythonhosted.org/packages/18/2e/28a7d361a568b1a6c86946674e8ac35a609573c3a3d12bb20f6aaf1c39bf/pbr-3.0.1.tar.gz"
    sha256 "d7e8917458094002b9a2e0030ba60ba4c834c456071f2d0c1ccb5265992ada91"
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
