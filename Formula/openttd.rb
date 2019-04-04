class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://proxy.binaries.openttd.org/openttd-releases/1.9.0/openttd-1.9.0-source.tar.xz"
  sha256 "45fded554d973328496f6e01b0769d7b8b64048a8fe2cf252242194c08ea7419"
  head "https://github.com/OpenTTD/OpenTTD.git"

  bottle do
    cellar :any
    sha256 "0c947600e90fc2bba15f9a04a394c7ae9df6c211d51e9b2e7de380b7e8c8d8c5" => :mojave
    sha256 "b631bb5a53e7e8b132cc81fadf25d5f451bcbf90d7086df0f7649e6ef0120cd5" => :high_sierra
    sha256 "b68d5c01aec086999fd2a5236855046e82f9b0044589ec3d6c6ae4abfd8f8533" => :sierra
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
