class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  # gmplib.org blocks GitHub server IPs, so it should not be the primary URL
  url "https://ftpmirror.gnu.org/gmp/gmp-6.3.0.tar.xz"
  mirror "https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz"
  sha256 "a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]
  compatibility_version 1
  head "https://gmplib.org/repo/gmp/", using: :hg

  livecheck do
    url "https://gmplib.org/download/gmp/"
    regex(/href=.*?gmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "5116a8201d8e044aef7d486da7e57f1e4dd2d8554ea6b540b44e45c0804f8f6f"
    sha256 cellar: :any, arm64_tahoe:       "fa46330de5d003bd9294ae042c8f4ae0a51bcb8c57de2c94c073ff4a7ffa10c3"
    sha256 cellar: :any, arm64_sequoia:     "b30bf31c50c294e0981d2a7cb4c149e9c43f50f3cf4f7f552c3dcf9da66b95b5"
    sha256 cellar: :any, arm64_sonoma:      "3ea4034c547217e84019dada2669c1f2cd4a44a1cf094ad4881ff525713077c5"
    sha256 cellar: :any, arm64_linux:       "6647e78fa0031ae48458496a4c46dee645fa8f8dda44d35f3a095627590e77b1"
    sha256 cellar: :any, x86_64_linux:      "0cb5dc6f783367a97202b5fd53e8f61a6024c5cfa075cf81aee15c05772ee9f3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "m4" => :build

  deny_network_access!

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
    args = %w[--enable-cxx --with-pic]

    cpu = Hardware::CPU.arm? ? "aarch64" : Hardware.oldest_cpu
    if OS.mac?
      args << "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"
    else
      args << "--build=#{cpu}-linux-gnu"
      args << "ABI=32" if Hardware::CPU.is_32_bit?
    end

    system "./configure", *args, *std_configure_args
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
