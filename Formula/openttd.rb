class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://binaries.openttd.org/releases/1.7.1/openttd-1.7.1-source.tar.xz"
  sha256 "61190952a98d494d3fd62e395dd6c359609914d0ba8fe80eaeb585b7d62a1b36"

  head "https://git.openttd.org/openttd/trunk.git"

  bottle do
    sha256 "ee0a3491f25aa0fa7630964adefaeefaa64a59391a2dc9ec0c83d4e90763abc2" => :sierra
    sha256 "2a795f3dc3823bb0752578c604f108da027bf2aa6d5a4fd9e057ae998c0de96b" => :el_capitan
    sha256 "0bd2dcec82c063194393a9dc784d5db0ca5a6e659b7562ce02680379ce4a7265" => :yosemite
  end

  depends_on "lzo"
  depends_on "xz"
  depends_on "pkg-config" => :build

  resource "opengfx" do
    url "https://bundles.openttdcoop.org/opengfx/releases/0.5.4/opengfx-0.5.4.zip"
    sha256 "3d136d776906dbe8b5df1434cb9a68d1249511a3c4cfaca55cc24cc0028ae078"
  end

  resource "opensfx" do
    url "https://bundles.openttdcoop.org/opensfx/releases/0.2.3/opensfx-0.2.3.zip"
    sha256 "3574745ac0c138bae53b56972591db8d778ad9faffd51deae37a48a563e71662"
  end

  resource "openmsx" do
    url "https://bundles.openttdcoop.org/openmsx/releases/0.3.1/openmsx-0.3.1.zip"
    sha256 "92e293ae89f13ad679f43185e83fb81fb8cad47fe63f4af3d3d9f955130460f5"
  end

  def install
    system "./configure", "--prefix-dir=#{prefix}"
    system "make", "bundle"

    (buildpath/"bundle/OpenTTD.app/Contents/Resources/data/opengfx").install resource("opengfx")
    (buildpath/"bundle/OpenTTD.app/Contents/Resources/data/opensfx").install resource("opensfx")
    (buildpath/"bundle/OpenTTD.app/Contents/Resources/gm/openmsx").install resource("openmsx")

    prefix.install "bundle/OpenTTD.app"
    bin.write_exec_script "#{prefix}/OpenTTD.app/Contents/MacOS/openttd"
  end

  def caveats; <<-EOS.undent
      If you have access to the sound and graphics files from the original
      Transport Tycoon Deluxe, you can install them by following the
      instructions in section 4.1 of #{prefix}/readme.txt
    EOS
  end

  test do
    assert_match /OpenTTD #{version}\n/, shell_output("#{bin}/openttd -h")
  end
end
