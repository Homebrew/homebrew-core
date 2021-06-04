class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.19/krb5-1.19.1.tar.gz"
  sha256 "fa16f87eb7e3ec3586143c800d7eaff98b5e0dcdf0772af7d98612e49dbeb20b"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_big_sur: "0a2528fac8efc2c289411944004f75c5bed52942bc5c2258636e47a1fab635f9"
    sha256 big_sur:       "d544c1111503eb27b253e190998b948889ea224b1ebecbceb6a4dd912317eb53"
    sha256 catalina:      "6a41de7c23c35b555a22349963df4114c498c5b91c345126a1e7deb7acbe31ea"
    sha256 mojave:        "7697a5ffefab32cacc4d34aec34cb03dab185776025d56d7442d6350cd9fadc1"
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  uses_from_macos "bison"

  on_linux do
    depends_on "gettext"
  end

  def install
    cd "src" do
      # Newer versions of clang are very picky about missing includes.
      # One configure test fails because it doesn't #include the header needed
      # for some functions used in the rest. The test isn't actually testing
      # those functions, just using them for the feature they're
      # actually testing. Adding the include fixes this.
      # https://krbdev.mit.edu/rt/Ticket/Display.html?id=8928
      inreplace "configure", "void foo1() __attribute__((constructor));",
                             "#include <unistd.h>\nvoid foo1() __attribute__((constructor));"

      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}",
                            "--without-system-verto",
                            "--without-keyutils"
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
