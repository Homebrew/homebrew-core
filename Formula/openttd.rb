class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/1.10.2/openttd-1.10.2-source.tar.xz"
  sha256 "939c55d259fb13cb47dfb3244e8f7b9e2f723883ebb2119410d8a282724eb6f5"
  head "https://github.com/OpenTTD/OpenTTD.git"

  bottle do
    cellar :any
    sha256 "c10dd30960f9a2ab4be89fcff49039117b1980c358fc363dfdb5023e818288df" => :catalina
    sha256 "980617dd4ae5e1b90c8d8995132e9be8a92f8ce1aa59c32f7a961de17f700ec7" => :mojave
    sha256 "85a7007f398d30ab259bae1ba7666a4b8b9fd4e2e1491b11f77b0f09a306b6c9" => :high_sierra
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
