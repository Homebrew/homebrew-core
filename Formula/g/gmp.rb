class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  # gmplib.org blocks GitHub server IPs, so it should not be the primary URL
  url "https://ftpmirror.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz"
  mirror "https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz"
  sha256 "a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]
  head "https://gmplib.org/repo/gmp/", using: :hg

  livecheck do
    url "https://gmplib.org/download/gmp/"
    regex(/href=.*?gmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "db8075f389ca0a9f9aba54762c93760db66ef92ee989f4a32b5e13b4b987339c"
    sha256 cellar: :any,                 arm64_sequoia:  "6683d73d6677d28e1e8d1b92d6ebfbc068c1d33e19b79114a22a648a99ba5991"
    sha256 cellar: :any,                 arm64_sonoma:   "78e4f40cba6419cf7e2d81e9c945d1e93744511bd5230bdfac1b69ed894914b4"
    sha256 cellar: :any,                 arm64_ventura:  "98c163edfbe7bdc0c14f88d7d34fa2764ecb9cab9f749600b861012700603260"
    sha256 cellar: :any,                 arm64_monterey: "2115b33b8b4052f91ffb85e476c7fc0388cf4e614af1ce6453b35e6d25473911"
    sha256 cellar: :any,                 tahoe:          "3f2654a4c29cd2b8605bea7a9473d6984ecbefa6413662b0d976f1457099f24d"
    sha256 cellar: :any,                 sequoia:        "d1192da68b2618652f4be0dd9f56b18d2d276481440ae241ce9cc17be0450e07"
    sha256 cellar: :any,                 sonoma:         "e8410d92339535174e9f4a5eccc403301b70c7287f2f9a87f064a9aa2e21b54b"
    sha256 cellar: :any,                 ventura:        "83ec5443c018c02036d88ae0dc8dc4237b3b38eb76a3cdd82148e7f841ffd39f"
    sha256 cellar: :any,                 monterey:       "b04023f65b8c79c45798a4bfd97fdbeb10f1bf9e8416e22e8eeedbd9b2a8c102"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5f23ebfcde217dbc697dc961d103ca602445a5775c2ed19a29eaec98f4cfa3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dca3544faca889c7389a5fdbd2b5b00582c34a4e14607033573ad3b06ca7882"
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
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-o", "test"
    system "./test"

    # Test the static library to catch potential linking issues
    system ENV.cc, "test.c", "#{lib}/libgmp.a", "-o", "test"
    system "./test"
  end
end
