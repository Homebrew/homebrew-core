class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.io"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.4.2.src.tar.xz"
  sha256 "eedffd9b9c19ff0be23315b690d66754fdd73c43aacb708a56e803d558271fdb"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dc8e09b6bd3d7093eaff147b7480342c3ed02a59a74fa19d61b1961df4f5f3d9"
    sha256 cellar: :any,                 arm64_big_sur:  "0fada2ab841d8519c6ca3ffab8ef38ea905a39be7a5c28733b1a591a64e946f3"
    sha256 cellar: :any,                 monterey:       "1e73928a8839a9ee2eafe4cee53b5e17312c2e9a522a42cc5a912d6105fc5c1b"
    sha256 cellar: :any,                 big_sur:        "3d26e04d26e94f19af1d3cb5449e19764429c6e7ed38dd072ec4feea0efa49ac"
    sha256 cellar: :any,                 catalina:       "5729c4ab18137b45af5d746632397100645f338ad72fc7225c35385a27c325cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7daa2723d8c757eb27d83e84cab1ec7aca20cb4961e49573d4bc87848ff66fe0"
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
    system "./configure", "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}"
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
