class Dict < Formula
  desc "Dictionary Server Protocol (RFC2229) client"
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/dictd/dictd-1.13.0/dictd-1.13.0.tar.gz"
  sha256 "eeba51af77e87bb1b166c6bc469aad463632d40fb2bdd65e6675288d8e1a81e4"
  license "GPL-2.0"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "23929a3cb0f10cbae3e5c1e9222cbc1422605739961331c3a6809c2fe5d6520d"
    sha256 arm64_big_sur:  "8e18fd5f8791cb97d71d38bce9e2190fab100fe578c70d2d8be17e2726e46931"
    sha256 monterey:       "fcaac6a257868b92ca7e205efa4aa03a4b2310a1dc6b4d4e484d3efe0296df66"
    sha256 big_sur:        "e6067e6141c67f672e798f885b2ae679e3e6246864891498d3146ae95935e04d"
    sha256 catalina:       "51af859a4f115e88b032dfdedb3c1a854af3c5daa19a97d4e796251dfa60ed4f"
    sha256 mojave:         "707b10a71cd00d48d591d44654147ac419a217e59c32702593fa6d8a27374f6b"
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
