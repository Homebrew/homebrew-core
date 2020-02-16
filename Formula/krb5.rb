class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.18/krb5-1.18.tar.gz"
  sha256 "73913934d711dcf9d5f5605803578edb44b9a11786df3c1b2711f4e1752f2c88"

  bottle do
    sha256 "e91d8a852288b491ceecd46e7324636d884bbb3b9a1085c08e7be9854e98dc91" => :catalina
    sha256 "68ea3e43598dd64035ea922507c22666d059836f337e882c6543e91d05f939d0" => :mojave
    sha256 "be007d08ecc596af4636657d618c845a1934ed0787705b3f906d408e977a7d26" => :high_sierra
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
