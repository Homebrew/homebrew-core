class Dict < Formula
  desc "Dictionary Server Protocol (RFC2229) client"
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/dictd/dictd-1.12.1/dictd-1.12.1.tar.gz"
  sha256 "a237f6ecdc854ab10de5145ed42eaa2d9b6d51ffdc495f7daee59b05cc363656"
  revision 1

  bottle do
    sha256 "e9b8fcd267281afc7144d63d38b6540a21dd3fb47a1fb0875b69b9162cb4c977" => :mojave
    sha256 "5a386048d25567d5c913fc46ca926d8f1f8abb152c00eb9c448552594a590bd4" => :high_sierra
    sha256 "5b4f21f0abaf403bc6599d5cf05dc0c9f0dedbc5d520940b5c5fccb3dc69326b" => :sierra
    sha256 "899c97bb0af187edb16eb91e516403f12977dc00293c5b86a6a3f6aeafb74ac8" => :el_capitan
  end

  depends_on "libtool" => :build
  depends_on "libmaa"

  def install
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
    (prefix+"etc/dict.conf").write <<~EOS
      server localhost
      server dict.org
    EOS
  end
end
