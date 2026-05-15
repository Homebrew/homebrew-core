class Nacl < Formula
  desc "Network communication, encryption, decryption, signatures library"
  homepage "https://nacl.cr.yp.to/"
  url "https://hyperelliptic.org/nacl/nacl-20110221.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/n/nacl/nacl_20110221.orig.tar.bz2"
  sha256 "4f277f89735c8b0b8a6bbd043b3efb3fa1cc68a9a5da6a076507d067fc3b3bf8"
  license :public_domain

  # On an HTML page, we typically match versions from file URLs in `href`
  # attributes. This "Installation" page only provides the archive URL in text,
  # so this regex is a bit different.
  livecheck do
    url "https://nacl.cr.yp.to/install.html"
    regex(%r{https?://[^\n]+?/nacl[._-]v?(\d+{6,8})\.t}i)
  end

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9e39e851dc41943d39fafb01f3040d14d11d4dba1cccdb9693bc0f2fed67297"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a885034a1e0e2c2a021508bee8ee850bb7b0db0bf6c185b3f884293d39b7796c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b62b27bd435d9a76504a88b02a457780e48e7948401cc27a5320d583fec1a3ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "7992b33222396efd6755e4253b8b1ae70907e2196c2c204765957c1d6afdfc23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41db87747bf6e0eea1fa8d48c14a24f58879ab7b397cfe03df118f841108e2af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bf782f00a46dfd9e8afef68c75d977504de8a5410a4d044ebd54f428245deb5"
  end

  depends_on "libcpucycles"

  # Apply Debian patches to fix build as upstream doesn't seem to be maintained
  patch do
    url "https://deb.debian.org/debian/pool/main/n/nacl/nacl_20110221-15.debian.tar.xz"
    sha256 "d45ad0681434e2f6bc83df0016aa03f3a49ef4c20fe5009b775df53824080ee3"
    apply "patches/0002-fix-ftbfs.patch",
          "patches/0100-cpucycles-disable-build.patch"
  end

  def install
    # Print the build to stdout rather than the default logfile.
    # Logfile makes it hard to debug and spot hangs. Applied by Debian:
    # https://sources.debian.net/src/nacl/20110221-4.1/debian/patches/output-while-building/
    # Also, like Debian, inreplace the hostname because it isn't used outside
    # build process and adds an unpredictable factor.
    inreplace "do" do |s|
      s.gsub! 'exec >"$top/log"', 'exec | tee "$top/log"'
      s.gsub!(/^shorthostname=`.*$/, "shorthostname=brew")
    end

    # Avoid unwanted compiler flags
    rm(["okcompilers/c", "okcompilers/cpp"])
    (buildpath/"okcompilers/c").write "#{ENV.cc}\n"
    (buildpath/"okcompilers/cpp").write "#{ENV.cxx}\n"

    system "./do" # This takes a while since it builds *everything*

    # NaCL has an odd compilation model and installs the resulting
    # binaries in a directory like:
    #    <nacl source>/build/<hostname>/lib/<arch>/libnacl.a
    #    <nacl source>/build/<hostname>/include/<arch>/crypto_box.h
    #
    # It also builds both x86 and x86_64 copies if your compiler can
    # handle it, but we install only one.
    archstr = Hardware::CPU.intel? ? "amd64" : "default"

    # Don't include cpucycles.h
    include.install Dir["build/brew/include/#{archstr}/crypto_*.h"]
    include.install "build/brew/include/#{archstr}/randombytes.h"

    # Add randombytes.o to the libnacl.a archive - I have no idea why it's separated,
    # but plenty of the key generation routines depend on it. Users shouldn't have to
    # know this.
    nacl_libdir = "build/brew/lib/#{archstr}"
    system "ar", "-r", "#{nacl_libdir}/libnacl.a", "#{nacl_libdir}/randombytes.o"
    lib.install "#{nacl_libdir}/libnacl.a"
  end

  test do
    # Based on tests/hash.c
    (testpath/"test.c").write <<~'C'
      #include <stdio.h>
      #include <crypto_hash.h>

      int main(void) {
        int i;
        unsigned char x[8] = "testing\n";
        unsigned char h[crypto_hash_BYTES];

        crypto_hash(h, x, sizeof(x));
        for (i = 0; i < crypto_hash_BYTES; ++i)
          printf("%02x", (unsigned int) h[i]);
        return 0;
      }
    C

    expected = "24f950aac7b9ea9b3cb728228a0c82b67c39e96b4b344798870d5daee93e3ae5" \
               "931baae8c7cacfea4b629452c38026a81d138bc7aad1af3ef7bfd5ec646d6c28"

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lnacl"
    assert_equal expected, shell_output("./test")
  end
end
