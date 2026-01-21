class Bic < Formula
  desc "C interpreter and API explorer"
  homepage "https://github.com/hexagonal-sun/bic"
  license "GPL-2.0-only"

  stable do
    url "https://github.com/hexagonal-sun/bic/releases/download/v1.0.0/bic-v1.0.0.tar.gz"
    sha256 "553324e39d87df59930d093a264c14176d5e3aaa24cd8bff276531fb94775100"

    on_macos do
      on_arm do
        # Need to use git archive tarball to apply patches which modify development/CI files
        url "https://github.com/hexagonal-sun/bic/archive/refs/tags/v1.0.0.tar.gz"
        sha256 "fa5b9e3ffc955220ab825a749f1987a7a0bd268693c1750a1af6cc1802217547"

        depends_on "autoconf" => :build
        depends_on "autoconf-archive" => :build
        depends_on "automake" => :build
        depends_on "bison" => :build # macOS bison is too outdated, build fails unless gnu bison is used
        depends_on "libtool" => :build
        depends_on "pkgconf" => :build

        # Backport to cleanly apply next patch
        patch do
          url "https://github.com/hexagonal-sun/bic/commit/97296b610350b3ae6abfb546dcae43fd32a002b3.patch?full_index=1"
          sha256 "32e732260a974cc48d757c0ed0a457467ed8f88025faf5637feca6e37a6e7788"
        end

        # Apply all commits from PR https://github.com/hexagonal-sun/bic/pull/49
        patch do
          url "https://github.com/hexagonal-sun/bic/compare/631cfb449eec35a2df52eb317f4e9add33c1dea9..7748c44eed2c53ce82b9d45a9f629f68f8cc4f99.patch"
          sha256 "bf10454ec8fededce5e9688d7ebabc0f74df3d50c24322efc0f4ee215a1879a9"
        end
      end
    end

    # Backport fix for error: call to undeclared function '__gmp_fprintf'
    patch do
      on_intel do
        url "https://github.com/hexagonal-sun/bic/commit/77f2993cd5b41bfa21fb21636588e459c6aaf45c.patch?full_index=1"
        sha256 "c7037e4f3b05be997744ccdea0f51786e5eafaddebc131763d5f45745e90cf00"
      end
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "95d273611ee6c62e77dbcf51696f2d1af33b20e76586a35d2e93975b92257cbe"
    sha256 cellar: :any,                 arm64_sequoia: "4d9fe97eade0c6ce2c65f69f49950a1f523351b31fb8f5c7d759617cf1aa0e9e"
    sha256 cellar: :any,                 arm64_sonoma:  "8394ce75075c03309cd99ebf48367e2bbc2f883a5e99be5256432547489802b5"
    sha256 cellar: :any,                 sonoma:        "4a93afe6568b694f333695ec33727a9545af2f981c546eb560205099afee3c68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d43b0b4a77554c2f5d43f0956994c5008368bd40d9246a364708457c8833932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18e8e74a600a6fd58a87eb2592dbc38c079bf9fd08b2e672c0e9a73ea66c0cce"
  end

  head do
    url "https://github.com/hexagonal-sun/bic.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build # macOS bison is too outdated, build fails unless gnu bison is used
    depends_on "libtool" => :build
    depends_on "pkgconf" => :build

    uses_from_macos "flex" => :build
    uses_from_macos "libffi"
  end

  depends_on "gmp"

  uses_from_macos "libedit" # readline's license is incompatible with GPL-2.0-only

  def install
    unless OS.mac?
      ENV.append_to_cflags "-I#{Formula["libedit"].opt_libexec}/include"
      ENV.append "LDFLAGS", "-L#{Formula["libedit"].opt_libexec}/lib"
    end

    system "autoreconf", "--force", "--install", "--verbose" if build.head? || (OS.mac? && Hardware::CPU.arm?)
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
