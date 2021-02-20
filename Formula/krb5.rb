class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.19/krb5-1.19.tar.gz"
  sha256 "bc7862dd1342c04e1c17c984a268d50f29c0a658a59a22bd308ffa007d532a2e"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_big_sur: "4dadb532e9c17eed0771ff3e53c50f51015f9ca65a29167282cd8fc28fe68092"
    sha256 big_sur:       "1dc799a415f88381e989d293afe85a5b888bc3b459ab8b51e39e7be684d8d7d4"
    sha256 catalina:      "ef229251840e4af08dedd2129ece37a18a25a5fefb7e139926aa22029a18716f"
    sha256 mojave:        "81ac0c47b76361155093ad5dfd58256c7a1f9d1b97f2b231a408659fb4bb7fec"
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
