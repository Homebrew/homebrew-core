class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  # gmplib.org blocks GitHub server IPs, so it should not be the primary URL
  url "https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz"
  mirror "https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz"
  sha256 "a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]
  head "https://gmplib.org/repo/gmp/", using: :hg

  livecheck do
    url "https://gmplib.org/download/gmp/"
    regex(/href=.*?gmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c83eb93b762bb88306d0dc963afe2ce70b394f6937b9fe98ded48193e62831ff"
    sha256 cellar: :any,                 arm64_ventura:  "2436cd120e5678d67c24020a50cbbf7c0220e7ecaac63981335872b9d666bcad"
    sha256 cellar: :any,                 arm64_monterey: "a43a2ae4c44d90626b835a968a32327c8b8bbf754ec1d2590f8ac656c71dace9"
    sha256 cellar: :any,                 arm64_big_sur:  "491220f1ff2c662b96295d931a80702523eeaee681d7305fb02b561e527dcbb8"
    sha256 cellar: :any,                 sonoma:         "b516363fe7f4b360144a2c6b88c61d9ddb0a82eb03a14c0b361567f9e8cdf62e"
    sha256 cellar: :any,                 ventura:        "4c6488dfd53b8287702827a4e6d50569926417f2cd08613d37720de54b6afe0c"
    sha256 cellar: :any,                 monterey:       "dddc6d8c871c92f6e5fb1249c28768aa2b4b47c38836a69cf787a639cf5eee73"
    sha256 cellar: :any,                 big_sur:        "e566452815d2ff5dc66da160bd1cd3d9cf02a17a07284cf0bac46496133383ae"
    sha256 cellar: :any,                 catalina:       "5ee7a460668864c28e541db15420e1480c3d31c5f216797a453a5310106fbc97"
    sha256 cellar: :any,                 mojave:         "b9d7d36c8d263be0e02e17d435350546f9f7008eb21b6e86bf42f719efcba85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "786ae29f0c0b06ea86e42bd9c6ac2c49bd5757da037dead7053e8bd612c4cf8c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "m4" => :build

  def install
    if build.head?
      system "./.bootstrap"
    else
      # Regenerate configure to avoid flat namespace linking
      # Reported by email: https://gmplib.org/list-archives/gmp-bugs/2023-July/thread.html
      # Remove in next version
      system "autoreconf", "-i", "-s"
    end

    # Enable --with-pic to avoid linking issues with the static library
    args = std_configure_args + %w[--enable-cxx --with-pic]

    cpu = Hardware::CPU.arm? ? "aarch64" : Hardware.oldest_cpu
    if OS.mac?
      args << "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"
    else
      args << "--build=#{cpu}-linux-gnu"
      args << "ABI=32" if Hardware::CPU.is_32_bit?
    end

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Prevent brew from trying to install metafiles that
    # are actually symlinks to files in autotools kegs
    buildpath.children.select(&:symlink?).map(&:unlink) if build.head?
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gmp.h>
      #include <stdlib.h>

      int main() {
        mpz_t i, j, k;
        mpz_init_set_str (i, "1a", 16);
        mpz_init (j);
        mpz_init (k);
        mpz_sqrtrem (j, k, i);
        if (mpz_get_si (j) != 5 || mpz_get_si (k) != 1) abort();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-o", "test"
    system "./test"

    # Test the static library to catch potential linking issues
    system ENV.cc, "test.c", "#{lib}/libgmp.a", "-o", "test"
    system "./test"
  end
end
