class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.32.5.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.32.5.tar.gz"
  sha256 "4872e12f802572dedd4b02f870065814b2d5141f7dbdaf708eedab826b51a58a"
  license "LGPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "917c81b362e5302ac4e01ee49ecc0eb2fdc3cce6e31dcff7cbdaaba941b11153"
    sha256 cellar: :any,                 arm64_monterey: "027ba3480af2d28fd16cff3ee115b47342e35ff6c6fe04c9d7f1c4b468314659"
    sha256 cellar: :any,                 arm64_big_sur:  "c74061ffaf150d29cff6bfb67d5f22c217e5a0b590be3883c98e4dbfea454920"
    sha256 cellar: :any,                 ventura:        "8235113576b3be4c86963ee69125ad9a8aed3128f4150ce2a1a1174992c2d6af"
    sha256 cellar: :any,                 monterey:       "76f1b4ccacd4c9bea1d4019872389e9797510fab82b5d37baf5e7f4d3cc92b73"
    sha256 cellar: :any,                 big_sur:        "ed1ed921e26e050aa439b491c1a95a0052ce1de21043c1908c820c77bce2aae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7889bddb775368d35458c31a88c135a279894fd73a194edf492fe0f3965dbec9"
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@1.1"

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
                          "--with-libs=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end
end
