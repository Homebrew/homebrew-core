class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.16/krb5-1.16.2.tar.gz"
  sha256 "9f721e1fe593c219174740c71de514c7228a97d23eb7be7597b2ae14e487f027"

  bottle do
    sha256 "9aef9157b57acb216b15e7517fabcbc721febf558749e77729f500c95a02fbb7" => :mojave
    sha256 "ac3539420efc0db874142ff42a58b31a8e95d91ee3f6387a2e52ff91f74a0dbf" => :high_sierra
    sha256 "5345fa53b64215a02f28ca3a6603275ab922cc6c9ae34d462cd16645db736862" => :sierra
    sha256 "bea43fed7870e621af7ebb5438f1fe3eaa84f5d6aed68cb2429e71155da397b9" => :el_capitan
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
