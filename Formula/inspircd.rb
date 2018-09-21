class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v2.0.26.tar.gz"
  sha256 "8a067add0132af57081f563bdca7ce6bb66c2e3c0465ce273b7eed1c5a955394"

  bottle do
    sha256 "ac48a4e4162b0f0851b45d88b4c44cadbce5d83996899c30529bf501082189e6" => :mojave
    sha256 "c6fe69a90b3a9388d5d900a034db918354970ef19c632aaffac499e7fe5287f2" => :high_sierra
    sha256 "35fa52bf0b05a8d2dab78025ab44c2197c0bf0c5f224571796f0b0e5d2b17ae6" => :sierra
    sha256 "35015617fd5117d9eed2d3370572ffb89d3e20cec9c86ceecab61eb26eb73024" => :el_capitan
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
