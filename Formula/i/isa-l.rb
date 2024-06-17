class IsaL < Formula
  desc "Intelligent Storage Acceleration Library"
  homepage "https://github.com/intel/isa-l"
  url "https://github.com/intel/isa-l/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "e218b7b2e241cfb8e8b68f54a6e5eed80968cc387c4b1af03708b54e9fb236f1"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "20183aa5fc7bdf83833ef924ad844a13bee2f95386cf783da45d2756577d00c1"
    sha256 cellar: :any,                 arm64_ventura:  "c0239e97ea4e8a1d185e49c646d51ec9ea498c70920a89247fadca5b84f5d68e"
    sha256 cellar: :any,                 arm64_monterey: "3a51e53bf3ad0bb50767d009ebb8697b6aba0b19109bcacf8ba5c9bcb1915ad0"
    sha256 cellar: :any,                 sonoma:         "e3f0efaabed341b094eea37d2cc6983ead4765ba23ed6b75aa7060bd3f3ef73a"
    sha256 cellar: :any,                 ventura:        "5167d8bb29d7f9f476be36e32ecfa8e0c2ea72d5ddf5578d5bb9a1c1c55a9de8"
    sha256 cellar: :any,                 monterey:       "b1539460388da543c470efc592d09f44c2acf5a6ada37d4802d6c7a28d7cff0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38df9950275b3bf11b6f9df9c060c28d041590cbd73ab217d8f33dee11e5bc4f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build

  # fix mach compilation
  patch do
    url "https://github.com/intel/isa-l/commit/f1b144bbab7cd1f603565b3b7f92bfb47b86e646.patch?full_index=1"
    sha256 "41a300e3155a281dbf05aa79d54250b19eda035a8166f5368c18867467475c0b"
  end

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
