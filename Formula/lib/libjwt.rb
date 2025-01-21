class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/releases/download/v2.1.1/libjwt-2.1.1.tar.bz2"
  sha256 "e50e7d88a5a6f04e3dbaffca5218869b7a14a26d8ecc9c791df858a1442a04d7"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "daa5896792307e4f7d10abe0d6cc7ddeb73f3d47aa0df00118084bee5bbb99e5"
    sha256 cellar: :any,                 arm64_sonoma:  "a6d8c2b927ba2a9a2c714a0cad90679740117584a335d09148b27e266da2ad2d"
    sha256 cellar: :any,                 arm64_ventura: "f1c799be3d920d4ce7733277a44068e149852e4160f01ed12b077443668a482b"
    sha256 cellar: :any,                 sonoma:        "ea8e79823c9a61dc7c6e9baf5e22751eeac5d88d70f4a32b4d215ea461697128"
    sha256 cellar: :any,                 ventura:       "abe2f477659a84800560e9e04f1cf75b3a1feedf8b546ce65f0d60c630bd3b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "759f89d1e9d8b9ab0fa8fbaada2b5235855d52db35c6106bb4af23d31fb31452"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <jwt.h>

      int main() {
        jwt_t *jwt = NULL;
        if (jwt_new(&jwt) != 0) return 1;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-ljwt", "-o", "test"
    system "./test"
  end
end
