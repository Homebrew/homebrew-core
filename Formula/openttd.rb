class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://binaries.openttd.org/releases/1.7.2/openttd-1.7.2-source.tar.xz"
  sha256 "fe51a0bade8fdf6ce3ec696418ecf75c95783cdcabfd7b204eec5c0bb5d149d4"

  head "https://git.openttd.org/openttd/trunk.git"

  bottle do
    rebuild 1
    sha256 "aa8a324b0400fab12eb52c8980d613d4630aa722314483742be46be5969e8285" => :high_sierra
    sha256 "3878a83345e59f8dc1994bd11c48d7e9b3307b9ef1c6228d0de3884ad5532ef5" => :sierra
    sha256 "51addb9fbdde6f2c6c76d80c13526626e501dfffdcdc97f3997773e8f55c12a8" => :el_capitan
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

  # Fix pre-existing bug triggering Xcode 9 build error
  # Upstream commit, remove when 1.8 is released
  patch do
    url "https://git.openttd.org/?p=trunk.git;a=commitdiff_plain;h=2f7ac7c41f46dfc0d16d963ea5c6de2f8d144971"
    sha256 "a2681e6ac7ccb2be2d591090198f343d1744484d7093e1e9866325cceecc8748"
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

  def caveats
    <<~EOS
      If you have access to the sound and graphics files from the original
      Transport Tycoon Deluxe, you can install them by following the
      instructions in section 4.1 of #{prefix}/readme.txt
    EOS
  end

  test do
    assert_match /OpenTTD #{version}\n/, shell_output("#{bin}/openttd -h")
  end
end
