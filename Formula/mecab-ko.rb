class MecabKo < Formula
  desc "See mecab"
  homepage "https://bitbucket.org/eunjeon/mecab-ko"
  url "https://bitbucket.org/eunjeon/mecab-ko/downloads/mecab-0.996-ko-0.9.2.tar.gz"
  version "0.996-ko-0.9.2"
  sha256 "d0e0f696fc33c2183307d4eb87ec3b17845f90b81bf843bd0981e574ee3c38cb"

  bottle do
    rebuild 1
    sha256 "d9655e7122ee6a56194faf5e44062c3bf3c2bf145ba6f8f7b3e6dd1154bf7516" => :catalina
    sha256 "a1a0b40d2cb5a689ae24a439af990c7a85f8136bfa2bc5c3fd0708300b2fd111" => :mojave
    sha256 "d254239a9fec5e99de9590feb8d7c82f87e31324908003b059aea9a5d6092f2a" => :high_sierra
    sha256 "86b35c767cb97ab0b5e895475c3254589b101bdc3c8666abc694ea9a480421ec" => :sierra
    sha256 "c348042904040c28772c3f8f299debe574c6ebaaed7e41b23cac4980aeb8aa97" => :el_capitan
  end

  conflicts_with "mecab", :becasue => "both install mecab binaries"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"

    # Put dic files in HOMEBREW_PREFIX/lib instead of lib
    inreplace "#{bin}/mecab-config", "${exec_prefix}/lib/mecab/dic", "#{HOMEBREW_PREFIX}/lib/mecab/dic"
    inreplace "#{etc}/mecabrc", "#{lib}/mecab/dic", "#{HOMEBREW_PREFIX}/lib/mecab/dic"
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/mecab/dic").mkpath
  end

  test do
    assert_equal "#{HOMEBREW_PREFIX}/lib/mecab/dic", shell_output("#{bin}/mecab-config --dicdir").chomp
  end
end
