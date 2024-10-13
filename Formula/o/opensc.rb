class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.25.1/opensc-0.25.1.tar.gz"
  sha256 "23cbaae8bd7c8eb589b68c0a961dfb0d02007bea3165a3fc5efe2621d549b37b"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "fa9c58cdbe0076a73a0494b4273b094fc82ed3ccd59b981ed9349ba2e7caf2ad"
    sha256 arm64_sonoma:  "617a60aa9c9b1c74eed3039bdb53b80e840dfb438961e9beddd2a35a1b2d4f18"
    sha256 arm64_ventura: "796458b80c3b0db6ebd476e65bfce1390f17071af732eb92aec17bf0aeb0b9b8"
    sha256 sonoma:        "a0557ac53fc3ec946b83608b41f34b409d9472f4819fa1b44c75f11c3e12e2e1"
    sha256 ventura:       "79641f78c3042a850cb0b2a63d329f26a15e21c64cb2094bcd5422263511606d"
    sha256 x86_64_linux:  "384bbb98200ae2b603cee378ce7723289fb4ac9d5ff62aca198392e1230dd8b2"
  end

  head do
    url "https://github.com/OpenSC/OpenSC.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
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
    on_high_sierra :or_newer do
      <<~EOS
        The OpenSSH PKCS11 smartcard integration will not work from High Sierra
        onwards. If you need this functionality, unlink this formula, then install
        the OpenSC cask.
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opensc-tool -i")
  end
end
