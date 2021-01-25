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
    rebuild 1
    sha256 "a72fae06ddd1d796a6c1ab55a9c8bc15e8e051c67e72412dbc86cea9bcd04c62" => :big_sur
    sha256 "1ef5fefe3b5811f6588e0182b4594caa831282bc55a2787d83c9df9f666b221e" => :arm64_big_sur
    sha256 "67f67b210947e2bd62d974b2494f1192f169fae35605f38f7b2f0a9a73eb0633" => :catalina
    sha256 "3d09843ed22dfe2ce8c193eb3c6183eee9c278e06f179773930a8017d649d312" => :mojave
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
