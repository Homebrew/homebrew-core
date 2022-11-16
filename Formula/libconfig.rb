class Libconfig < Formula
  desc "Configuration file processing library"
  homepage "https://hyperrealm.github.io/libconfig/"
  url "https://github.com/hyperrealm/libconfig/releases/download/v1.7.3/libconfig-1.7.3.tar.gz"
  sha256 "545166d6cac037744381d1e9cc5a5405094e7bfad16a411699bcff40bbb31ee7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2bf05c92de1c235a0ba6f4ff4fb37d2451bf50057b5af52ecabb1a03ea3892fd"
    sha256 cellar: :any,                 arm64_monterey: "8074ac817099b848dfda57a98dcb10eac98781d1aeb85425d6e1713650da8c09"
    sha256 cellar: :any,                 arm64_big_sur:  "e675d6e4c47ca13fe8a8faaf02364c5e09c43f7212b33040aa49c06a808c077c"
    sha256 cellar: :any,                 ventura:        "b5b55ab30a17d2c5c66dd3ea18b6368452683b2ffdeec4892af58f5e65220470"
    sha256 cellar: :any,                 monterey:       "c5fe41cc40b814c29ddfe551058e204f2e50e76dd056aeae57d28cca24be672e"
    sha256 cellar: :any,                 big_sur:        "90fad29e719a3bd1b8ebe4eb857299b8a78a229543c3062d370bcdcfa0b8cd5c"
    sha256 cellar: :any,                 catalina:       "88689325264c406acb9f624b0c66cae10e2c7b5874b4d78335751b4627a5496c"
    sha256 cellar: :any,                 mojave:         "f5470e709146445744e2f9a200e0ea8042be9cd144a3e0b9f0a664b07e1aadc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ddc0a7e749416e1a6f0b1eb2f96fc272af064f5f0f447c647b5d996d798eace"
  end

  head do
    url "https://github.com/hyperrealm/libconfig.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    uses_from_macos "flex" => :build

    on_system :linux, macos: :ventura_or_newer do
      depends_on "texinfo" => :build
    end
  end

  def install
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libconfig.h>
      int main() {
        config_t cfg;
        config_init(&cfg);
        config_destroy(&cfg);
        return 0;
      }
    EOS
    system ENV.cc, testpath/"test.c", "-I#{include}",
           "-L#{lib}", "-lconfig", "-o", testpath/"test"
    system "./test"
  end
end
