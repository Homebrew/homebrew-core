class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v3.1.0.tar.gz"
  sha256 "5fd6b30e0285dd2bcf6fd135ffce52a08d8452f820a02e0068ac471e99d465ba"

  bottle do
    sha256 "de7c0627908828d4ec8b317cbf174f043598b38c1916fa64dab5c8b76411ac2d" => :mojave
    sha256 "679569e694341552a1cc4d50240ebbd28f77850f0adfc482d0e3ddc1a7736495" => :high_sierra
    sha256 "45b3a6258e87954cb82f98d97ca87d54f4063a06f5b8cdff645ba0be4bf994bb" => :sierra
  end

  if MacOS.version <= :sierra
    depends_on "openssl" => :build
  end

  depends_on "pkg-config" => :build

  skip_clean "data"
  skip_clean "logs"

  def install
    system "./configure", "--enable-extras=m_ldapauth.cpp,m_ldapoper.cpp"
    system "./configure", "--prefix=#{prefix}", "CXX=#{ENV.cxx}"
    system "make", "install"
  end

  test do
    system "#{bin}/inspircd", "--version"
  end
end
