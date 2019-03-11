class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.16/krb5-1.16.2.tar.gz"
  sha256 "9f721e1fe593c219174740c71de514c7228a97d23eb7be7597b2ae14e487f027"

  bottle do
    sha256 "2a65570080ab6a01c73b77b318502881e13c9e3e7203607b8b31aab6fa3ff876" => :mojave
    sha256 "b4031c03425dcbd98f7f7d2b505542b06b18054b947b92cff85563446c4eccbc" => :high_sierra
    sha256 "e6964cbea39ddef11af37c8f431567c1aa97b92ee31763be311268b922c2e5e1" => :sierra
  end

  keg_only :provided_by_macos

  depends_on "openssl"

  def install
    cd "src" do
      system "./configure",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--without-system-verto"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/krb5-config", "--version"
    assert_match include.to_s,
      shell_output("#{bin}/krb5-config --cflags")
  end
end
