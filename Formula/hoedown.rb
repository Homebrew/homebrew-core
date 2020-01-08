class Hoedown < Formula
  desc "Secure Markdown processing (a revived fork of Sundown)"
  homepage "https://github.com/hoedown/hoedown"
  url "https://github.com/hoedown/hoedown/archive/3.0.7.tar.gz"
  sha256 "01b6021b1ec329b70687c0d240b12edcaf09c4aa28423ddf344d2bd9056ba920"

  bottle do
    cellar :any_skip_relocation
    sha256 "578d2db4436012569cd56a47cca8967e106cd83474ed80f52dd7deeda6b1a134" => :catalina
    sha256 "4028b7bb88b6da75f735c58f3497d354dda4bc7ce33288a0ae71932878991c5b" => :mojave
    sha256 "1be6101d978f2df1749712dd39d3fc8b9c7cc014c2402eab5060e8656f6b22cf" => :high_sierra
    sha256 "f940a418b3ca712a91e8b782d61618a2b1cf2c662a98f636e4df1318fbb9f508" => :sierra
    sha256 "7076f6f7c091919a3619a5a5655270d79dab42fdb6d7dfdc3f1324318ca4ec6d" => :el_capitan
    sha256 "fc37aa79feca395a49b3e15348d8156721ba1713dfb740622c57a696d1ec5e58" => :yosemite
    sha256 "9940929bd2ede20f973f29fdac888c6b664188bf29e9a1f7c8eba0eeb42e6206" => :mavericks
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
