class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.io"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.4.2.src.tar.xz"
  sha256 "eedffd9b9c19ff0be23315b690d66754fdd73c43aacb708a56e803d558271fdb"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eaa2aba06bcf5a18480ad6607f5608bb35a53870bc22ee4e15b70bbcc02c9e48"
    sha256 cellar: :any,                 arm64_big_sur:  "b826320b92fb86236b12368bf174448f179edb2980f7fb64f37227a909181a61"
    sha256 cellar: :any,                 monterey:       "1cb34598857ff62cb830a33f65e45406a71101455a452c78c75c8aa90dfe021c"
    sha256 cellar: :any,                 big_sur:        "47b6bf8d8219f9d51843bbcdbbe91a33605a3681f7d7065f8591f51663cda394"
    sha256 cellar: :any,                 catalina:       "79ba155dbf5b6d026293fe4247542a75fcf4b2cdc08428067a0fdddb2957fc83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "928577ad45fa3aa001aff0599bd526f14b097f670ae54ebe397963a2e9e9db98"
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
