class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.6.1.tar.bz2"
  sha256 "072451ac1e0dc97ed69a2e5bfc235fd94fe093d837f65584d0e3581af5db18cd"
  license "BSD-3-Clause"

  livecheck do
    url "https://libopenraw.freedesktop.org/exempi/"
    regex(/href=.*?exempi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9b0039aab7afdf72220e267ed55d8cf7e93c6ecccfcd553b8ff15f4a4870a34b"
    sha256 cellar: :any,                 arm64_big_sur:  "029f2d0d2fc76899e05db89a2c91b80d591797c995ed570467fa6da3e14cefb4"
    sha256 cellar: :any,                 monterey:       "19a13f4ea1b3945dfee190b7fac9be56c191fea8c732ec262d8367ede305ee11"
    sha256 cellar: :any,                 big_sur:        "a4e20a9d71550b11df0172f57569d783e66f051dc5f7848b18d112bdde086225"
    sha256 cellar: :any,                 catalina:       "3ce93a31d89460a07f0fd81a7540b12001be170c56cb5b28d39b3f2f9df44582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e383e49241a48787db09f24ce10fa0648cd0ed33030c230976c66ee1b784f40"
  end

  depends_on "boost"

  uses_from_macos "expat"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end
