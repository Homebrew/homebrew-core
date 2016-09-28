class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"

  stable do
    url "https://botan.randombit.net/releases/Botan-1.10.13.tgz"
    sha256 "23ec973d4b4a4fe04f490d409e08ac5638afe3aa09acd7f520daaff38ba19b90"

    # upstream ticket: https://bugs.randombit.net/show_bug.cgi?id=267
    patch :DATA
  end

  bottle do
    cellar :any
    sha256 "b04c99b1028e05ee50e28faa590caa40b0cd3d1603fec0da3e61fb64419b39d6" => :sierra
    sha256 "21599053348caae11ed972522334247733ea85776ca5c8d309bcf1aea39d28fa" => :el_capitan
    sha256 "70592ff415e7e30c7a50c2aa46a8b4a0357150c5f98fb1fa11bba5ea48ee978b" => :yosemite
    sha256 "da4e989fedc710e3e65cb6ec387b9fd865740cc1878f660f371522ba255b307f" => :mavericks
  end

  devel do
    url "https://botan.randombit.net/releases/Botan-1.11.31.tgz"
    sha256 "0e751c9182c84f961e90be51f086b1ec254155c3d056cbb37eebff5f5e39ddee"
  end

  option "with-debug", "Enable debug build of Botan"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "openssl"

  needs :cxx11 if build.devel?

  def install
    ENV.cxx11 if build.devel?

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --cpu=#{MacOS.preferred_arch}
      --cc=#{ENV.compiler}
      --os=darwin
      --with-openssl
      --with-zlib
      --with-bzip2
    ]

    args << "--enable-debug" if build.with? "debug"

    system "./configure.py", *args
    # A hack to force them use our CFLAGS. MACH_OPT is empty in the Makefile
    # but used for each call to cc/ld.
    system "make", "install", "MACH_OPT=#{ENV.cflags}"
  end

  test do
    # stable version doesn't have `botan` executable
    if stable?
      assert_match "lcrypto", shell_output("#{bin}/botan-config-1.10 --libs")
    else
      (testpath/"test.txt").write "Homebrew"
      (testpath/"testout.txt").write Utils.popen_read("#{bin}/botan base64_enc test.txt")
      assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
    end
  end
end

__END__
--- a/src/build-data/makefile/unix_shr.in
+++ b/src/build-data/makefile/unix_shr.in
@@ -57,8 +57,8 @@
 LIBNAME       = %{lib_prefix}libbotan
 STATIC_LIB    = $(LIBNAME)-$(SERIES).a

-SONAME        = $(LIBNAME)-$(SERIES).%{so_suffix}.%{so_abi_rev}
-SHARED_LIB    = $(SONAME).%{version_patch}
+SONAME        = $(LIBNAME)-$(SERIES).%{so_abi_rev}.%{so_suffix}
+SHARED_LIB    = $(LIBNAME)-$(SERIES).%{so_abi_rev}.%{version_patch}.%{so_suffix}

 SYMLINK       = $(LIBNAME)-$(SERIES).%{so_suffix}
