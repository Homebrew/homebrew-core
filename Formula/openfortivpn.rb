class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.9.0.tar.gz"
  sha256 "2087e9b6d785037d1eb0cf28c889612b7774dd3bf7652da15a43fc33068581d9"

  bottle do
    sha256 "f90028421a138d158dbc999c801612c18439692f350a07f4212a2e52d7e2f0fd" => :mojave
    sha256 "45dfd4656767ecb047f26f26dea898dc223a8bdd57e9e747194ef519db124358" => :high_sierra
    sha256 "11c168aa5e680d933295cf0454787bcfc359c56ec474ee812a756032e0b7723d" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    system bin/"openfortivpn", "--version"
  end
end
