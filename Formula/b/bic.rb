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
    sha256 cellar: :any,                 arm64_tahoe:   "7c0da289a9629c8fb1d74ebfef9c8159ac00103096a72d39bff315f3f41a3c14"
    sha256 cellar: :any,                 arm64_sequoia: "841382877c009debae638924434b00e76b275e7c77f43f1c11f1b55f9dec44f7"
    sha256 cellar: :any,                 arm64_sonoma:  "901a803c50e0438b0132876f3ecc970087894ace6608113234848cec89a3d059"
    sha256 cellar: :any,                 sonoma:        "4f122a009440f01cdaa97ac0fdf69e7aa8a0b31082e7fc8fb7d08b5c8ecf2307"
    sha256 cellar: :any,                 ventura:       "b2949645cf730b7d5b1a9286c5134775190c8353a9e8dbc28af7414b97f63253"
    sha256 cellar: :any,                 monterey:      "cfa83a9ccd1d192b77af48d3198acf0f082d9f929a6256bb978f293543210940"
    sha256 cellar: :any,                 big_sur:       "36f71fa3f987da036e8bf8cefd3e640479868f2eb033f307848679b41d7ee393"
    sha256 cellar: :any,                 catalina:      "41d1871d125642f8437b5bb7b74f205b0eee956be0ad46b7677680b76764c0cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1eed9e3fd17cead07b28471dc8cfd46754b81e0db2ff0ecf631223e1e08dfb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2744bafd1615ee75b148b2b4ef18a3acdb0cf7a33c71014b541cb3f820c1b38f"
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

  on_linux do
    depends_on "readline"
  end

  def install
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
