class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.17/krb5-1.17.tar.gz"
  sha256 "5a6e2284a53de5702d3dc2be3b9339c963f9b5397d3fbbc53beb249380a781f5"
  revision 1

  bottle do
    sha256 "a73183fac51592371795af726b991893db251dbacbcad5e9b0c2f1eb41dd1f62" => :mojave
    sha256 "beaa308f53f9586fa64a07cb62cc8b349365be3169ec08c9cf669ad3445dcfc7" => :high_sierra
    sha256 "375b6f6caf39eb186368e949b864d84d75f0af792ef31c3b8de59e3669ba645f" => :sierra
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  def install
    cd "src" do
      system "./configure", "--disable-debug",
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
