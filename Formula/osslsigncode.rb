class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/2.0.tar.gz"
  sha256 "5a60e0a4b3e0b4d655317b2f12a810211c50242138322b16e7e01c6fbb89d92f"

  bottle do
    cellar :any
    rebuild 2
    sha256 "ce350145e5e0d0b3dc19042ccca189ec124519a4c5b5cd67319d7f1d517e1a1e" => :mojave
    sha256 "987a7f92ca9d86ecc687e6cdb7758a1c87db8d15e0307c9f6ad3c392ccc63f4b" => :high_sierra
    sha256 "1fcfa6be97026cd27145c79289c10c19ab123bd50ff682ed57236475368dd5cb" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Requires Windows PE executable as input, so we're just showing the version
    assert_match "osslsigncode", shell_output("#{bin}/osslsigncode --version", 255)
  end
end
