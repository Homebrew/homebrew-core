class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.8.2.tar.gz"
  sha256 "6a1831bfdbf8f424c7508aba47b045d51341ec0fde9122f38b0b86b096ef533e"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f71a38aeb0c7441b58f3f3053e6d3d393c30cf6c914ef11c5194eb06c391cb34"
    sha256 cellar: :any,                 arm64_monterey: "02e3599b1bb2d4b09b9bd5bc0bfbeb130399b21f12b69da17835eeca8d4e1a9d"
    sha256 cellar: :any,                 arm64_big_sur:  "53373a88d3f917f29bcd1f1cc7bd400de4b1df7284b95bf0ed9f51dfbc41107b"
    sha256 cellar: :any,                 ventura:        "ba9b4d7ea8f1b00c442398ad5c4b9ef24caf0d5ae0197128732d627bc98bbfdf"
    sha256 cellar: :any,                 monterey:       "597479e27bda9170ed22056191f7433e6c59d7516ad45362d633f4e28345a3b4"
    sha256 cellar: :any,                 big_sur:        "9d88e53ece8634044ef3ddae31ab626e249265d3f8b4456166f4fec89700a49c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43f301d1855fdf9c3a9cecb4e8a63f180995eda2d0d2f504af6c332762b89c95"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "openssl@3"

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
