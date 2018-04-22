class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v2.0.26.tar.gz"
  sha256 "8a067add0132af57081f563bdca7ce6bb66c2e3c0465ce273b7eed1c5a955394"

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
