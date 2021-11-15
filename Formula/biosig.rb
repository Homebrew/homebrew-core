class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.io"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.3.3.src.tar.gz"
  sha256 "ecff695e912265cbb817b936209086d1b5854afeb44ed58e701feeb2e0b1b33e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "78ec41c72351ea192f6774b3c9cef32fb840f8abdabae586afd92aabfa6fc936"
    sha256 cellar: :any,                 big_sur:      "d11e9df24b03c09b1e07eb5aa04a32caad78094e084de9de8b586b3eca722d87"
    sha256 cellar: :any,                 catalina:     "68bffa7d07f5551de7f675264ac4e4699b96117a39b4a44ad14d7810247f7929"
    sha256 cellar: :any,                 mojave:       "bd14850fc19217a2be2b9f530ede8caad279783db51106534b88c9321bfe8a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0c36f98a2fed1e3cb6d02729619b09429dda34a0a67aef6fd347dac5287e5b7d"
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
