class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.10.0.tar.gz"
  sha256 "d6ea0c84c0cf811530073fa19865334bb42ab10a780157fe95c4efb3476ad58d"
  revision 1

  bottle do
    sha256 "4ba2c3ca99e7f799a74e4e0fdf9b755681309297bd1dd6237d076ea4a0caeb59" => :mojave
    sha256 "9ad39cc736a5eb30e3d6cc077deb5a5fbe3edca01b16d6f50fee87740dce2bf8" => :high_sierra
    sha256 "7914365ffec1cdb05e19c776557d5cbde976f2930dae3397428e8c254103d781" => :sierra
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
