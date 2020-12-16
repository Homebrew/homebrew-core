class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.18/krb5-1.18.3.tar.gz"
  sha256 "e61783c292b5efd9afb45c555a80dd267ac67eebabca42185362bee6c4fbd719"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 "ce41211e7264912be6fc05d8e5ed3bbc141679b0ab6c9b4099a36da811077a9f" => :big_sur
    sha256 "9bcf67f6ca1757dd425a7fd4c0fcd2d42273c01b303f4219b16714793c89fd0d" => :arm64_big_sur
    sha256 "f50ff30a8268899f65150363f294ddcbd1969759f8700efac874caa181bca75d" => :catalina
    sha256 "4e5751f16b7e6d9f27968a9efb1ba5f702292c7fefdb25a32c940ef71f81b7cd" => :mojave
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
