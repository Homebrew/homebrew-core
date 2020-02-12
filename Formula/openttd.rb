class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://proxy.binaries.openttd.org/openttd-releases/1.9.3/openttd-1.9.3-source.tar.xz"
  sha256 "1988e17f5b6f4b8f423c849ef1c579c21f678722ae4440f87b27a5fea6385846"
  head "https://github.com/OpenTTD/OpenTTD.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5257e2533ce2e76334b8262b9f2e565420d462e08855c29f1c6a63e76998a00d" => :catalina
    sha256 "14851bf281a3cdda6bb754cb4b6442507ec4ba9512d0d7339fdc091e199a5899" => :mojave
    sha256 "ebcab33997053d2aceeffba777e6e78c5d8d677d1e122e2b478a2c3226a9a4ce" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lzo"
  depends_on "xz"

  resource "opengfx" do
    url "https://binaries.openttd.org/extra/opengfx/0.5.5/opengfx-0.5.5-all.zip"
    sha256 "c648d56c41641f04e48873d83f13f089135909cc55342a91ed27c5c1683f0dfe"
  end

  resource "opensfx" do
    url "https://binaries.openttd.org/extra/opensfx/0.2.3/opensfx-0.2.3-all.zip"
    sha256 "6831b651b3dc8b494026f7277989a1d757961b67c17b75d3c2e097451f75af02"
  end

  resource "openmsx" do
    url "https://binaries.openttd.org/extra/openmsx/0.3.1/openmsx-0.3.1-all.zip"
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
