class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.18/krb5-1.18.2.tar.gz"
  sha256 "c6e4c9ec1a98141c3f5d66ddf1a135549050c9fab4e9a4620ee9b22085873ae0"

  bottle do
    sha256 "db39e4570abab6459fb857cb41fdd0a375810d25a4c712f4504585255397d150" => :catalina
    sha256 "e35ce1f9da67683b70fa075f4317a476c8356860c0a1c935d6a56eaee6716e8e" => :mojave
    sha256 "972a37782e92d2dec91a9f6cd90d2a98f4004101268579e1a1d6c3650014bed4" => :high_sierra
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  uses_from_macos "bison"

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
