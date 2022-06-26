class Hoedown < Formula
  desc "Secure Markdown processing (a revived fork of Sundown)"
  homepage "https://github.com/hoedown/hoedown"
  url "https://github.com/hoedown/hoedown/archive/3.0.7.tar.gz"
  sha256 "01b6021b1ec329b70687c0d240b12edcaf09c4aa28423ddf344d2bd9056ba920"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c91387f585953da59a7587de33a6085642da3d55a416c6d1a99839340df531f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "748004674d9036262032eda6a9b574137cff8a01178977c45d735adba7160587"
    sha256 cellar: :any_skip_relocation, monterey:       "a3a6b53be859368f6565a31c918758648fa6c41f833ccd2419961fb3b01ecaa9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8878fa04ace3327364bb0d18113bbb56006f169d7f169bc41d03986e1bfe6270"
    sha256 cellar: :any_skip_relocation, catalina:       "578d2db4436012569cd56a47cca8967e106cd83474ed80f52dd7deeda6b1a134"
    sha256 cellar: :any_skip_relocation, mojave:         "4028b7bb88b6da75f735c58f3497d354dda4bc7ce33288a0ae71932878991c5b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "1be6101d978f2df1749712dd39d3fc8b9c7cc014c2402eab5060e8656f6b22cf"
    sha256 cellar: :any_skip_relocation, sierra:         "f940a418b3ca712a91e8b782d61618a2b1cf2c662a98f636e4df1318fbb9f508"
    sha256 cellar: :any_skip_relocation, el_capitan:     "7076f6f7c091919a3619a5a5655270d79dab42fdb6d7dfdc3f1324318ca4ec6d"
    sha256 cellar: :any_skip_relocation, yosemite:       "fc37aa79feca395a49b3e15348d8156721ba1713dfb740622c57a696d1ec5e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d9c93dc9fcdfd9daa56e0dc4c410ec0003a11150b211124bc0c367098fb5132"
  end

  def install
    system "make", "hoedown"
    bin.install "hoedown"
    prefix.install "test"
  end

  test do
    system "perl", "#{prefix}/test/MarkdownTest_1.0.3/MarkdownTest.pl",
                   "--script=#{bin}/hoedown",
                   "--testdir=#{prefix}/test/MarkdownTest_1.0.3/Tests",
                   "--tidy"
  end
end
