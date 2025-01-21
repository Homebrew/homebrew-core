class IsaL < Formula
  desc "Intelligent Storage Acceleration Library"
  homepage "https://github.com/intel/isa-l"
  url "https://github.com/intel/isa-l/archive/refs/tags/v2.31.1.tar.gz"
  sha256 "5c9da8f2024c1949457e91226d73cd71e52ec4574803899f0d600ee9e58c3561"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6bc5013abd53459542e5ae34601a89d12e8d7ef496938cc73ff2ca9e9959f945"
    sha256 cellar: :any,                 arm64_sonoma:  "d6ed28d3bd60bc3d5101a80a6d0dd115623cc81ae2e3675ed94ab71b8950b43f"
    sha256 cellar: :any,                 arm64_ventura: "3167c838574ee9cc7c09a31a87b7823a6b2de3d9e522d13ca6ec3f1b70c91b79"
    sha256 cellar: :any,                 sonoma:        "56a08d986c604d2800e03819b521d2fecac4af595fbdb66c79090b2f3961ca19"
    sha256 cellar: :any,                 ventura:       "833a3eced0fda7d8e15e6d5d75363c0f221fa91e6f04464099d59dcc3cbc3fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe15b388084f75d25b81e4c24dc350fdce19538ae107432fa8a6be740c765e8e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
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
