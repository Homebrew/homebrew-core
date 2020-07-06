class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/1.10.2/openttd-1.10.2-source.tar.xz"
  sha256 "939c55d259fb13cb47dfb3244e8f7b9e2f723883ebb2119410d8a282724eb6f5"
  license "GPL-2.0"
  head "https://github.com/OpenTTD/OpenTTD.git"

  bottle do
    cellar :any
    sha256 "8acdc3d403b125fad2fc1ae5c59e37528fe98d47beb79cb0509a49ddbebce636" => :catalina
    sha256 "1d6f2b4a6df282fbd53aa8a88ef3a722e3d5d3b4a8f82b306b3ad6851038fc1b" => :mojave
    sha256 "4ea9ad94978b8f40c35e60ddca64de7795dc0faf36fb4967a676879ca8221444" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lzo"
  depends_on "xz"

  resource "opengfx" do
    url "https://cdn.openttd.org/opengfx-releases/0.6.0/opengfx-0.6.0-all.zip"
    sha256 "d419c0f5f22131de15f66ebefde464df3b34eb10e0645fe218c59cbc26c20774"
  end

  resource "opensfx" do
    url "https://cdn.openttd.org/opensfx-releases/0.2.3/opensfx-0.2.3-all.zip"
    sha256 "6831b651b3dc8b494026f7277989a1d757961b67c17b75d3c2e097451f75af02"
  end

  resource "openmsx" do
    url "https://cdn.openttd.org/openmsx-releases/0.3.1/openmsx-0.3.1-all.zip"
    sha256 "92e293ae89f13ad679f43185e83fb81fb8cad47fe63f4af3d3d9f955130460f5"
  end

  def install
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

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
    assert_match "OpenTTD #{version}\n", shell_output("#{bin}/openttd -h")
  end
end
