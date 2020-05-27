class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.14.1.tar.gz"
  sha256 "bc62fc6ecaaa6c6f8f2510e14a067a0cb9762158d9460c04555990bba44b50ca"

  bottle do
    sha256 "24503fbd02ac8e4a01375736e1cb969d107e7b8f648f77b499c12ee60107c9dc" => :catalina
    sha256 "34d19a2a925c131deb5b29a06b03000ef91864c7a2d0ceeb1e19276060089b37" => :mojave
    sha256 "2a6916f7bc0742cdd3c028c9990790b547b95e971f6786204d3d04ebc631db6b" => :high_sierra
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
