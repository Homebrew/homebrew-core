class Mboxgrep < Formula
  desc "Scan a mailbox for messages matching a regular expression"
  homepage "http://www.mboxgrep.org"
  url "https://downloads.sourceforge.net/project/mboxgrep/mboxgrep/0.7.9/mboxgrep-0.7.9.tar.gz"
  sha256 "78d375a05c3520fad4bca88509d4da0dbe9fba31f36790bd20880e212acd99d7"

  bottle do
    cellar :any
    sha256 "93f800f8bae502815c85bac9dd2d7ec85599caa1ee08b6a4860ca8db11ab7276" => :mojave
    sha256 "431d64ae6c1387c69b052942ee6b268ac9afbcd5bfff9d02bc21aeeaaa9807dd" => :high_sierra
    sha256 "44a294d075cb08e577c4d1c1e45c222bea93f3c8488f9bed54ded5b36797f536" => :sierra
    sha256 "ecc1d1a83a7ffbc3414feb24c970b89509737f7d1de5c0d8dbd71ba55e008220" => :el_capitan
    sha256 "08cbb574005db6e34cc191ae4f46670ca35af252e4e6bbc2041a92e32397bc49" => :yosemite
    sha256 "bb5cefa83e2fb8b37dac858f3119aedb338b29e0eb2715cbff08b4644689ad86" => :mavericks
  end

  depends_on "pcre"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/mboxgrep", "--version"
  end
end
