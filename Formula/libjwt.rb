class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/releases/download/v1.15.3/libjwt-1.15.3.tar.gz"
  sha256 "6775095bcd417d375faddc1f17cdd7706ad8aa9b9b02404990c4b0ee218ee379"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f0dab7b04493c0e5153fc17a0b672dd323321c9bdb49ec9daaa512c4bb432e98"
    sha256 cellar: :any,                 arm64_monterey: "42d06ded1180f824db3a490a5c343941a2703931361bec1bf49b5d2a35d8bbb8"
    sha256 cellar: :any,                 arm64_big_sur:  "4cfaf8c62ff186564b62a8498d3c39866ad17f0710e9ea4a97002fedea1a2c93"
    sha256 cellar: :any,                 ventura:        "3f2d008733adee0ef2a972b8bc0ed4871826eb53c3c43074f7e31a9451bf48d7"
    sha256 cellar: :any,                 monterey:       "e7eb0838d2020ec1ad60092c67396054ce2b9db5fba1eb6ea1b15c255dd41fd8"
    sha256 cellar: :any,                 big_sur:        "97357f9ffb6e1e8c16eb2cec37e9657d70a67a014be3ce727533a65607d54227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d71ab6776202034f9e1e9323e520762af18d901c572105d231665a3df34a837"
  end

  head do
    url "https://github.com/benmcollins/libjwt.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <jwt.h>

      int main() {
        jwt_t *jwt = NULL;
        if (jwt_new(&jwt) != 0) return 1;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-ljwt", "-o", "test"
    system "./test"
  end
end
