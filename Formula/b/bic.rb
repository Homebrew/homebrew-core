class Bic < Formula
  desc "C interpreter and API explorer"
  homepage "https://github.com/hexagonal-sun/bic"
  license "GPL-2.0-only"

  stable do
    url "https://github.com/hexagonal-sun/bic/releases/download/v1.0.0/bic-v1.0.0.tar.gz"
    sha256 "553324e39d87df59930d093a264c14176d5e3aaa24cd8bff276531fb94775100"

    on_macos do
      depends_on arch: :x86_64
    end

    # Backport fix for error: call to undeclared function '__gmp_fprintf'
    patch do
      url "https://github.com/hexagonal-sun/bic/commit/77f2993cd5b41bfa21fb21636588e459c6aaf45c.patch?full_index=1"
      sha256 "c7037e4f3b05be997744ccdea0f51786e5eafaddebc131763d5f45745e90cf00"
    end
  end

  bottle do
    sha256 cellar: :any,                 sonoma:       "4f122a009440f01cdaa97ac0fdf69e7aa8a0b31082e7fc8fb7d08b5c8ecf2307"
    sha256 cellar: :any,                 ventura:      "b2949645cf730b7d5b1a9286c5134775190c8353a9e8dbc28af7414b97f63253"
    sha256 cellar: :any,                 monterey:     "cfa83a9ccd1d192b77af48d3198acf0f082d9f929a6256bb978f293543210940"
    sha256 cellar: :any,                 big_sur:      "36f71fa3f987da036e8bf8cefd3e640479868f2eb033f307848679b41d7ee393"
    sha256 cellar: :any,                 catalina:     "41d1871d125642f8437b5bb7b74f205b0eee956be0ad46b7677680b76764c0cb"
    sha256 cellar: :any,                 mojave:       "36575a3c3444985140e94eba8fe8f6711fff5433eb7f17141c4b4ae30e1f2bf7"
    sha256 cellar: :any,                 high_sierra:  "23f308f2bfda3b9ee498680e08565997818570d74d1280137ef940f70801b8d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2744bafd1615ee75b148b2b4ef18a3acdb0cf7a33c71014b541cb3f820c1b38f"
  end

  head do
    url "https://github.com/hexagonal-sun/bic.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build # macOS bison is too outdated, build fails unless gnu bison is used
    depends_on "libtool" => :build

    uses_from_macos "flex" => :build
    uses_from_macos "libffi"
  end

  depends_on "gmp"

  on_linux do
    depends_on "readline"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main () {
        puts("Hello Homebrew!");
      }
    C
    assert_equal "Hello Homebrew!", shell_output("#{bin}/bic -s hello.c").strip
  end
end
