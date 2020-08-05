class Dict < Formula
  desc "Dictionary Server Protocol (RFC2229) client"
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/dictd/dictd-1.13.0/dictd-1.13.0.tar.gz"
  sha256 "eeba51af77e87bb1b166c6bc469aad463632d40fb2bdd65e6675288d8e1a81e4"

  bottle do
    sha256 "cd01d30024209e614bbe8614f4e7ef1c468a8994c3f8f13df618ba115b7749cb" => :catalina
    sha256 "f1887f0f6cf6acaf113f393938f09dc50a7b9ac2b01b0e3689d1c7241f3e4d08" => :mojave
    sha256 "a050d2b5ac7c9ff4535ddd7e397757694b679ed8b1be5c2a2768a9b8de9ed49c" => :high_sierra
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
