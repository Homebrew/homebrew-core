class Nacl < Formula
  desc "Network communication, encryption, decryption, signatures library"
  homepage "https://nacl.cr.yp.to/"
  url "https://hyperelliptic.org/nacl/nacl-20110221.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/n/nacl/nacl_20110221.orig.tar.bz2"
  sha256 "4f277f89735c8b0b8a6bbd043b3efb3fa1cc68a9a5da6a076507d067fc3b3bf8"

  # On an HTML page, we typically match versions from file URLs in `href`
  # attributes. This "Installation" page only provides the archive URL in text,
  # so this regex is a bit different.
  livecheck do
    url "https://nacl.cr.yp.to/install.html"
    regex(%r{https?://[^\n]+?/nacl[._-]v?(\d+{6,8})\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, ventura:      "8295f77303ae90ec9c22cfb16f5d676b435804447edc5347ab5f1a8d55ea2ddd"
    sha256 cellar: :any_skip_relocation, monterey:     "925c585e1140b37453c5f7ac60f944221e1de495654aefc70d5352e43fa0f730"
    sha256 cellar: :any_skip_relocation, big_sur:      "89574694f733c8aa852e09e3828f10dd6ce2ece4219bd825e5f6c18253bddb28"
    sha256 cellar: :any_skip_relocation, catalina:     "b9fb1445709388168d0e1c56964a7540e8ff4e6294d31eb23c62368ce56e6d1b"
    sha256 cellar: :any_skip_relocation, mojave:       "bb0b22e1aa3a87657b064def3d19bcad419a4339889046f931a5eac7e5bc8bc1"
    sha256 cellar: :any_skip_relocation, high_sierra:  "43fffe959f6a95aacff4d5d4b7bfbb34f835a2487e8bff0645473d8ec1de83b6"
    sha256 cellar: :any_skip_relocation, sierra:       "86e5ef1c0a14b029d1ed3f63df48fde9c302adbbc3e1dcacd1bb7617bf547615"
    sha256 cellar: :any_skip_relocation, el_capitan:   "e08c93b814989405fa3b7db9e3a9c4f149e36aaab32aba44e9a2f1659d2d3efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "03cbc3623ab6388289a613b8499f4e120d19cda47b661bd494e0d0cdfc355288"
  end

  depends_on arch: :x86_64

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

    system "./do" # This takes a while since it builds *everything*

    # NaCL has an odd compilation model and installs the resulting
    # binaries in a directory like:
    #    <nacl source>/build/<hostname>/lib/<arch>/libnacl.a
    #    <nacl source>/build/<hostname>/include/<arch>/crypto_box.h
    #
    # It also builds both x86 and x86_64 copies if your compiler can
    # handle it, but we install only one.
    archstr = "amd64"

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
end
