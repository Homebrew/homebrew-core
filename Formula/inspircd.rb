class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v2.0.25.tar.gz"
  sha256 "c2488fafd04fcabbd8ddc8b9cdc6e0b57e942802b451c9cbccaf5d8483ebd251"

  bottle do
    rebuild 1
    sha256 "6d5945ade2fe12374ecacebf55a9135d3c659bd876c0c18f5f37103f298f3310" => :high_sierra
    sha256 "c3ab8b2f60734e7abd19dc719816d7437f678677dd39499aaf8e449481a3d11e" => :sierra
    sha256 "da7687c4e9aeef5c215309667bf5a8311ea09524b42ee54d34e3bf1be309b4e4" => :el_capitan
  end

  skip_clean "data"
  skip_clean "logs"

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--enable-extras=m_ldapauth.cpp,m_ldapoper.cpp"
    system "./configure", "--prefix=#{prefix}", "--with-cc=#{ENV.cc}"
    system "make", "install"
  end

  def post_install
    inreplace "#{prefix}/org.inspircd.plist", "ircdaemon", ENV["USER"]
  end

  test do
    system "#{bin}/inspircd", "--version"
  end
end
