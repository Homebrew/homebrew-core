class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v2.0.27.tar.gz"
  sha256 "6bc1956bd6a7d2d463c646f1563c99cb507f2f214e51d6ac9c70906ac27aae73"

  bottle do
    sha256 "8d0b4455f893654aa729369b74ffed990fc554fd9b6d4902fdf1b8ee66e44c5e" => :catalina
    sha256 "de7c0627908828d4ec8b317cbf174f043598b38c1916fa64dab5c8b76411ac2d" => :mojave
    sha256 "679569e694341552a1cc4d50240ebbd28f77850f0adfc482d0e3ddc1a7736495" => :high_sierra
    sha256 "45b3a6258e87954cb82f98d97ca87d54f4063a06f5b8cdff645ba0be4bf994bb" => :sierra
  end

  depends_on "pkg-config" => :build

  skip_clean "data"
  skip_clean "logs"

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
