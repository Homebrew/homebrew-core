class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.io"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.3.2.src.tar.gz"
  sha256 "0bf97608fb0bfb2e474abe40c02de5b902d55810afdbd5959c7ba9725a120d5c"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 big_sur:      "ae96f3a8066f229dec3c3731d038deec95e28178d1484711f2464164d0cd50ad"
    sha256 cellar: :any,                 catalina:     "c749c7059004f7921be08564486ced1d2ee8d96b53046e3d95a78efd5bce9371"
    sha256 cellar: :any,                 mojave:       "d5d9917926fd98e298b74e2171d5b58c2b766e6865cd32e21db4cf9d9935ac0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "99c899470b00013a1ba1955d1f834d566add0c43e7887595f2b6eefb6b9fd33c"
  end

  depends_on "gawk" => :build
  depends_on "libarchive" => :build
  depends_on "dcmtk"
  depends_on "libb64"
  depends_on "numpy"
  depends_on "suite-sparse"
  depends_on "tinyxml"

  resource "test" do
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
    testpath.install resource("test")
    assert_match "NumberOfChannels", shell_output("#{bin}/save2gdf -json TEST_44x86_e1.GDF").strip
    assert_match "NumberOfChannels", shell_output("#{bin}/biosig_fhir TEST_44x86_e1.GDF").strip
  end
end
