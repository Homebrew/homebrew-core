class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.26.1/opensc-0.26.1.tar.gz"
  sha256 "f16291a031d86e570394762e9f35eaf2fcbc2337a49910f3feae42d54e1688cb"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "e30686709adbd2ed9e741d46ee7732ba4bdc26835662f674ad97d4a15c14f00b"
    sha256 arm64_sequoia: "0ae0073b4ba388df854a2c1bb2a31ad83e4ff800eb392d25779403defdff1ab2"
    sha256 arm64_sonoma:  "4e7694a574e648659e39287e6f79dd5b78c48f284cc186a9a5877a3dfbd0972f"
    sha256 arm64_ventura: "b6920b3fcde75811501cea04279e70647e5abd1a437783a3cfce8fb56082e6c7"
    sha256 sonoma:        "f6bdfbbcd8b3653f27d220af9f28794857e750ce919efded28f635869abc379c"
    sha256 ventura:       "3b59686f5df7f25f6b7b03ca4945921f4fca3831c8ae433563ee80647b545ff9"
    sha256 arm64_linux:   "d8a00ba58da4990a87c84d051092c088db6f904571f6b4e1db962ac9f5bb4e83"
    sha256 x86_64_linux:  "d4c613660abb6981348a4b68e8108ec48dbd081b3651c5b847a32cfd03ad073e"
  end

  head do
    url "https://github.com/OpenSC/OpenSC.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "pcsc-lite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "glib"
    depends_on "readline"
  end

  def install
    args = %W[
      --disable-silent-rules
      --enable-openssl
      --enable-pcsc
      --enable-sm
      --with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    on_macos do
      <<~EOS
        The OpenSSH PKCS11 smartcard integration will not work.
        If you need this functionality, unlink this formula, then install
        the OpenSC cask.
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opensc-tool -i")
  end
end
