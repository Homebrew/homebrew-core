class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.8.2.tar.gz"
  sha256 "6a1831bfdbf8f424c7508aba47b045d51341ec0fde9122f38b0b86b096ef533e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d81a25668452f78ca788fadeb35a9a2f7f111154b9347f31458e4a66d24c5eb8"
    sha256 cellar: :any,                 arm64_monterey: "e124dee69556b5ad055366ced3581ccc42ae96690e3d88bc61024a9d45372d45"
    sha256 cellar: :any,                 arm64_big_sur:  "dbbbf3fcd6709ee6ff2939eb2bbb31ada72521ec8e27054b0c59e6c901dc1b04"
    sha256 cellar: :any,                 ventura:        "d02a38e57961407a137dbfec82254ac0ed8d68e27894a9c8bcc09b4eecd16ce3"
    sha256 cellar: :any,                 monterey:       "672f530bf96cd1cb964b4ddf0ef7b637f0da7968b354ee993ad561d37236f5cc"
    sha256 cellar: :any,                 big_sur:        "c1cd904d2e98cd1b8644f7f58e4a3d9c44ffb11fd6f9f8f41c2c1c6779d2b1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3535a93e21796d3db967f183fe18774c70d0062f8f3df2bfee6f5214b8c7615e"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "openssl@1.1"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "six" => :build # macOS Python has `six` installed.
  end

  def install
    ENV["PYTHON"] = "python3"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-java",
                          "--disable-perl",
                          "--disable-php5",
                          "--disable-php7",
                          "--disable-python",
                          "--prefix=#{prefix}",
                          "--with-pkg-config=#{ENV["PKG_CONFIG_PATH"]}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <lasso/lasso.h>

      int main() {
        return lasso_init();
      }
    EOS
    system ENV.cc, "test.c",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{Formula["libxml2"].include}/libxml2",
                   "-I#{Formula["libxmlsec1"].include}/xmlsec1",
                   "-L#{lib}", "-llasso", "-o", "test"
    system "./test"
  end
end
