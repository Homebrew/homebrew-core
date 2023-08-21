class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.32.5.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.32.5.tar.gz"
  sha256 "4872e12f802572dedd4b02f870065814b2d5141f7dbdaf708eedab826b51a58a"
  license "LGPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "067c2328e9be5322fd20c7d42737feaca1a5709bbfcededb555581d7dde1c244"
    sha256 cellar: :any,                 arm64_monterey: "8553df4ae9d74929e324042df5438a1b147f7690e22f9a4e81d7b2f436c3c546"
    sha256 cellar: :any,                 arm64_big_sur:  "a3f8ec3228b44953f7ef33ea81ecdb5f8d2e69584e4cd3979af449f3afa178f4"
    sha256 cellar: :any,                 ventura:        "7c678c5230ee94f52200648cde8cdb076120df15ab48a2c02d1a7d1445f3e0b9"
    sha256 cellar: :any,                 monterey:       "fe2ed998931a1293944b258e9330aa5497ddccdeb8c08321937bfc1e32fdc4dc"
    sha256 cellar: :any,                 big_sur:        "08657cfdbcd1a1fb1d1cfc1d2a51ae85071a5456f99bc2e57f238cf86565670f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd85b0bd8ae4c89bf4b4d34ca44166992cbb650e20b22622a574f6cf7ce38943"
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  def install
    # Work around configure issues with Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--disable-static",
                          "--disable-nls",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end
end
