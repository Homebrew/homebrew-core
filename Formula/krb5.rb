class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://web.mit.edu/kerberos/dist/krb5/1.14/krb5-1.14.4.tar.gz"
  sha256 "03a61a4280c9161771fb39019085dbe6a57aa602080515ff93b43cd6137e0b95"

  bottle do
    sha256 "7d96e5c66f9b33d816ad2ef7f593c553f787c389a48d99bb7790354549b70b6b" => :sierra
    sha256 "86864f7c528286ef53f173032ca87b0911c71f1b3a04d0fd482faa2985dde301" => :el_capitan
    sha256 "1ca8042ea545878c3cc2bd10354b921bbd50c23eb538888e0603134c20eaf7bb" => :yosemite
  end

  keg_only :provided_by_osx

  depends_on "openssl"

  def install
    cd "src" do
      system "./configure",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}"
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
