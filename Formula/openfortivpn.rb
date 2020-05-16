class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.14.0.tar.gz"
  sha256 "3144056a93991ff77d52467a18ff72ab6c3349ebcea8642ceb3136c1091e3b98"

  bottle do
    sha256 "20733d9f71e196180a7e8f682dd3af3ed76862074bddd2a53db2fd70154ac2db" => :catalina
    sha256 "b16bab7320dd902a6c3a1f68cd939d0c91246d3a104c9fd85134c6900ef0a850" => :mojave
    sha256 "e9daee3b0d0c87436f49317eb496e5b138c0e46a462c2f98574f8fd6c54cf283" => :high_sierra
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
