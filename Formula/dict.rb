class Dict < Formula
  desc "Dictionary Server Protocol (RFC2229) client"
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/dictd/dictd-1.12.1/dictd-1.12.1.tar.gz"
  sha256 "a237f6ecdc854ab10de5145ed42eaa2d9b6d51ffdc495f7daee59b05cc363656"

  bottle do
    sha256 "741517b409486d621c4a99d397c786c2969c9c65f321b002dc7cf07890a624e8" => :sierra
    sha256 "1179c34c302af33595d7f6890b081496591437ea5f9497c048779fdc03058942" => :el_capitan
    sha256 "e54952913d23f81def2cec2b65ac94c5385180fa8970f613843546740435adfd" => :yosemite
    sha256 "b41fe59b8db4eb263ca23398ca8a52f6a23893ddfeb1b26f2e7ce9fdd8b08bf5" => :mavericks
  end

  depends_on "libtool" => :build
  depends_on "libmaa"

  def install
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
    (prefix+"etc/dict.conf").write <<-EOS
server localhost
server dict.org
EOS
  end
end
