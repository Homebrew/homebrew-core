class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.io"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.4.3.src.tar.xz"
  sha256 "7b6000e2275c00a67d7a25aaf7ffad229978d124315f5f910844b33a8a61e532"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7d3632944e57d136b6bf699d4432f198c827238e5e1aa03cc1341695432876d3"
    sha256 cellar: :any,                 arm64_big_sur:  "79b12acef4c4669df3e6e10813465312866bee222351bd92baec489f2de17d37"
    sha256 cellar: :any,                 monterey:       "55b5a9b22d796aea1b396f3a7d3013697f6e67e5359812b5aa2af7cfad60a346"
    sha256 cellar: :any,                 big_sur:        "2c99928984267a81311641e769d0ea5cc8dd4ae6f44864e5d4b25ff905c661dc"
    sha256 cellar: :any,                 catalina:       "8603db7018ad4d749663604999cdb125336b9bf8b447f9b8b9bb9a1fa1ba77ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3474e47278905262c292114b850627fc9881bd27b9a2f74ed95f2deea86e6ba"
  end

  depends_on "gawk" => :build
  depends_on "libarchive" => :build
  depends_on "dcmtk"
  depends_on "libb64"
  depends_on "numpy"
  depends_on "suite-sparse"
  depends_on "tinyxml"

  resource "homebrew-test" do
    url "https://pub.ist.ac.at/~schloegl/download/TEST_44x86_e1.GDF"
    sha256 "75df4a79b8d3d785942cbfd125ce45de49c3e7fa2cd19adb70caf8c4e30e13f0"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data",
                 shell_output("#{bin}/biosig_fhir 2>&1").strip
    testpath.install resource("homebrew-test")
    assert_match "NumberOfChannels", shell_output("#{bin}/save2gdf -json TEST_44x86_e1.GDF").strip
    assert_match "NumberOfChannels", shell_output("#{bin}/biosig_fhir TEST_44x86_e1.GDF").strip
  end
end
