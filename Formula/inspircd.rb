class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v2.0.25.tar.gz"
  sha256 "c2488fafd04fcabbd8ddc8b9cdc6e0b57e942802b451c9cbccaf5d8483ebd251"

  bottle do
    sha256 "fa0c21347636bbcf3cdb50606bc993607a705d6fc740d7af61c3d637af21aa42" => :high_sierra
    sha256 "cb4476a4883acb2a5d6aac17d7f8879fe1938ce34e8d37d97e5761e74ac4ce50" => :sierra
    sha256 "b73cab6e0683569ce510aff2f6817174e1986d2fa468bf344c812222cfc0b7f7" => :el_capitan
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
