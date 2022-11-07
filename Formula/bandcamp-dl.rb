class BandcampDl < Formula
  include Language::Python::Virtualenv

  desc "Simple python script to download Bandcamp albums"
  homepage "https://github.com/iheanyi/bandcamp-dl"
  url "https://files.pythonhosted.org/packages/cb/6f/08d0e2b1819327e375ebf67af0689727b2d49db7c0d11d4829552ea01ae4/bandcamp-downloader-0.0.13.tar.gz"
  sha256 "c7dbf489b2611406148a6ced25e5814b1fe666e3b3da6c744cfc3df2abe1b270"
  license "Unlicense"
  revision 1
  head "https://github.com/iheanyi/bandcamp-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5af7e33bb21b5a47ac1c6c3359b0c093b766b6671c33a2d752fb8d62a04b23bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "740426007611040a0ca4f88ac764305cdf8457e3a6aa26db30bc946c31ba2133"
    sha256 cellar: :any_skip_relocation, monterey:       "0817cfad6cec0e7a3cd3a31f066b130b6a3523e364f80bd7f46d41a6452f5986"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c8663468cbf93d0395be6a48e200988dd39261cba9642ba9ad647aa8eea6de2"
    sha256 cellar: :any_skip_relocation, catalina:       "84aa7d4976484752644b3341283b5826c6490cbd024f4975d1b9bee0391e0f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48fa086d5a1fe6b40d1ed2acf6735f77cc681dc3f0d895253678cb4975f1300f"
  end

  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/e8/b0/cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7/beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/31/a2/12c090713b3d0e141f367236d3a8bdc3e5fca0d83ff3647af4892c16c205/chardet-5.0.0.tar.gz"
    sha256 "0368df2bfd78b5fc20572bb4e9bb7fb53e2c094f60ae9993339e8671d0afb8aa"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "demjson3" do
    url "https://files.pythonhosted.org/packages/f7/d2/6a81a9b5311d50542e11218b470dafd8adbaf1b3e51fc1fddd8a57eed691/demjson3-3.0.6.tar.gz"
    sha256 "37c83b0c6eb08d25defc88df0a2a4875d58a7809a9650bd6eee7afd8053cdbac"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/e2/be/3ea39a8fd4ed3f9a25aae18a1bff2df7a610bca93c8ede7475e32d8b73a0/mock-4.0.3.tar.gz"
    sha256 "7d3fbbde18228f4ff2f1f119a45cdffa458b4c0dee32eb4d2bb2f82554bac7bc"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/b1/54/d1760a363d0fe345528e37782f6c18123b0e99e8ea755022fd51f1ecd0f9/mutagen-1.46.0.tar.gz"
    sha256 "6e5f8ba84836b99fe60be5fb27f84be4ad919bbb6b49caa6ae81e70584b55e58"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
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
    url "https://files.pythonhosted.org/packages/0b/25/37c77fc07821cd06592df3f18281f5e716bc891abd6822ddb9ff941f821e/Unidecode-1.3.6.tar.gz"
    sha256 "fed09cf0be8cf415b391642c2a5addfc72194407caee4f98719e40ec2a72b830"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
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
