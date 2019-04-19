class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.17/krb5-1.17.tar.gz"
  sha256 "5a6e2284a53de5702d3dc2be3b9339c963f9b5397d3fbbc53beb249380a781f5"

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
