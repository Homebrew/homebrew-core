class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.6.0.tar.gz"
  sha256 "205ab5ac512cbeee3c7a6f693518420ae66d6414c1d27247d002167e1906d6d3"

  bottle do
    sha256 "964ee366d0cd33ece25e9235761aa424dd01e3e17f18720c79aeac2091e5b3ff" => :high_sierra
    sha256 "64e74a9365601be04eceb6a9a6122aeac621360fb7b6c477f74dbb92991d1814" => :sierra
    sha256 "ecb13f914741c5a0edcb43a006f016731428d23ffebea94b4a7b20522a04ef09" => :el_capitan
    sha256 "dd96c9f517a603e2a352a632a801e4d87fbc5588f0f01b6b62764924482732fd" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
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
