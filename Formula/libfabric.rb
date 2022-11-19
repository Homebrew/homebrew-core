class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.16.1/libfabric-1.16.1.tar.bz2"
  sha256 "53f992d33f9afe94b8a4ea3d105504887f4311cf4b68cea99a24a85fcc39193f"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "27fcdd0efd7e8cb9c9c3ab2bd753652aea58797ab5d5e1dc21ea78965df2f416"
    sha256 cellar: :any,                 arm64_monterey: "d0ef41555d16ef392456abd4f7adc4d836ae986d6142265dc967089b5ddfd654"
    sha256 cellar: :any,                 arm64_big_sur:  "dd53fa0772b081652dbd851a9c9021221b973012a41daf99f4066fbb9921c592"
    sha256 cellar: :any,                 ventura:        "6626d21e58c0cc8b7ea66e50bb1f6326a863aa13812b9d5dbfa295674959ab60"
    sha256 cellar: :any,                 monterey:       "112ca924b5cca67d91f1ec102e68db13a8a1c934df43f48d78a5319635e2ffbe"
    sha256 cellar: :any,                 big_sur:        "66cffcac1e77eebf6a7b395f46d8726eba1feb5892a94ef60653a672de95760f"
    sha256 cellar: :any,                 catalina:       "591163806258adc24cc89a71eeff81ba85dfb67799012bf63facb8febc5f6abf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5bb8f38d64ddc25ec8662866d3b23f46aaae450c8c83c6d214d0e4cd7b81f3a"
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
