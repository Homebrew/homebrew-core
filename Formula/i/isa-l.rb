class IsaL < Formula
  desc "Intelligent Storage Acceleration Library"
  homepage "https://github.com/intel/isa-l"
  url "https://github.com/intel/isa-l/archive/refs/tags/v2.32.1.tar.gz"
  sha256 "d9f7179ab0e14a3db9b610fac22793854a1435e8423ec9ce07f4cbedc5f92f5e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bc6e6381b5a9df13aef59a6b14b9a4eee9263b09a409cf2dabbacb122aa2e630"
    sha256 cellar: :any, arm64_sequoia: "13aa54060840fb0f9894541046869602fed6f9cb7ae2d7ec76a7a8b9a896ab7e"
    sha256 cellar: :any, arm64_sonoma:  "accfcf0c6903777fe6d7b14e6b928091345997906e986e969affdb00c5e0ea25"
    sha256 cellar: :any, sonoma:        "7a2fdd00e9a2956a2f71f2d48e21ce9319366c4be467d1b42c7a0b4852300e08"
    sha256 cellar: :any, arm64_linux:   "5dd17424a8280ca9de4e1121304de8fce1024baad20f7f271d5a29262aff5985"
    sha256 cellar: :any, x86_64_linux:  "1bf091047b0178f924a70cc66aa5d286423a29af04fa48623537cae8947fb1a8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/ec/ec_simple_example.c", testpath
    inreplace "ec_simple_example.c", "erasure_code.h", "isa-l.h"
    system ENV.cc, "ec_simple_example.c", "-L#{lib}", "-lisal", "-o", "test"
    assert_match "Pass", shell_output("./test")
  end
end
