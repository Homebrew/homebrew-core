class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.18/krb5-1.18.tar.gz"
  sha256 "73913934d711dcf9d5f5605803578edb44b9a11786df3c1b2711f4e1752f2c88"

  bottle do
    sha256 "d71c0a4c545daa56558c27a7073d0c9a44825374136c68b9089bd4f137912cc6" => :catalina
    sha256 "88fb8afbea9dee3d4deb76f6d3059e1782a503ec587a3fffb62ebcb4d92d3b48" => :mojave
    sha256 "197acc476020f30796fa8651a7382edb63a40bbf2a4907dc726e0a4185287a5a" => :high_sierra
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  uses_from_macos "bison"

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
