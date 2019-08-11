class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.80.tar.bz2"
  sha256 "fcfa5a0e42099e12e4bf7a68ebe6fde05553383a682e816a7ec9256ab4773faa"
  head "https://svn.nmap.org/nmap/"

  bottle do
    sha256 "aeee2490ad36fd69eef721804739973058c87284d2882da621529ec55d7c4b4c" => :mojave
    sha256 "14f1bf9bd3f84f5008f4a3005f3f6f245c4c23162f4b935c9afa90610f34e0cb" => :high_sierra
    sha256 "e06900a582cdbacfb201d38d72b906f882871bcf30d776f0192cc540a6902f5a" => :sierra
  end

  depends_on "openssl"

  conflicts_with "ndiff", :because => "both install `ndiff` binaries"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-libpcre=included
      --with-liblua=included
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    rm_f Dir[bin/"uninstall_*"] # Users should use brew uninstall.
  end

  test do
    system "#{bin}/nmap", "-p80,443", "google.com"
  end
end
