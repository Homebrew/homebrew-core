class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.17/krb5-1.17.tar.gz"
  sha256 "5a6e2284a53de5702d3dc2be3b9339c963f9b5397d3fbbc53beb249380a781f5"
  revision 1

  bottle do
    sha256 "5a7813c3578552367965e704310aa0d78247df52def0aacb308f7f637acf6b76" => :catalina
    sha256 "f879534f9d242bcfe8f788854db6b80d08dfa5b8a77aea0e2309824e4b66d3e9" => :mojave
    sha256 "11a94abdbe1f318c5c60eb6abfbeb8cf20b80625c16472e9fd70869f85111433" => :high_sierra
    sha256 "b2016e6c49deebe1f581a17fc0c00ccee982f8740b2d37a9bcff28ff4c91c33b" => :sierra
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
