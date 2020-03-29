class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.13.2.tar.gz"
  sha256 "998fb2b071cdfe3255c2f953cafc6e1496778f9a71dd5aa560b924a44636df87"

  bottle do
    sha256 "091cc01925175a4dd27b020331b4d07065f8d5e643a62fafeec604fafb6b4df4" => :catalina
    sha256 "4ca89b43c5e2297d199621b2dcb5fc4a2a0cacdb8d15e3f75257585b5be794b0" => :mojave
    sha256 "18edf8df18ffbac38c2f88a795ff1c77c272082562f3be6b0b63f78ef6ebf900" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

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
