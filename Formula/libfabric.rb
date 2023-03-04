class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.17.1/libfabric-1.17.1.tar.bz2"
  sha256 "8b372ddb3f46784c53fdad50a701a6eb0e661239aee45a42169afbedf3644035"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a560e5af2f44c81d2975b785f7352691064d7fd40a5801e41aa81a071f8e27cb"
    sha256 cellar: :any,                 arm64_monterey: "b47867e82490d7e98701f055b8e60d0255429953eff8b63d4351f3f466f6c9fc"
    sha256 cellar: :any,                 arm64_big_sur:  "56bc0e41773c830c3156a675e453689977b3be87106d22ebdfe7c67a80b51eb1"
    sha256 cellar: :any,                 ventura:        "54281d9fe2471d565afee452bfd7d19fefb92708f71a0ab2979f9e1ec1111da3"
    sha256 cellar: :any,                 monterey:       "2d24dd08d6eebe7ffbef65ade13cbc14c0edc9a30d4b4ae45160c6f2ed562d13"
    sha256 cellar: :any,                 big_sur:        "3fc8bbd0cd05125fdbe3fc2e34864bccc59d3d6df95a6eef1e8830e5552846ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8208f023a7593aeda45218f44dc2958a6a7ad11ab33077c53f8d000fb314fa04"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  on_macos do
    conflicts_with "mpich", because: "both install `fabric.h`"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "provider: sockets", shell_output("#{bin}/fi_info")
  end
end
