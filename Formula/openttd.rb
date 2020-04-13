class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/1.10.1/openttd-1.10.1-source.tar.xz"
  sha256 "0d22a3c50f7a321f4f211594f4987ac16c381e8e3e40f116848e63e91e7fbb9b"
  head "https://github.com/OpenTTD/OpenTTD.git"

  bottle do
    cellar :any
    sha256 "5f3aa0fb700f08ec4b85e849f00802a11cc44e51b1ce5ddcdf92a3eea874ed07" => :catalina
    sha256 "c98cef289313ce1e34b44e34d7dab842094574f39ab86ac0ccf70a9fe668f035" => :mojave
    sha256 "dd6c81a1bf197eb445ceb9acbbade734409f39f16d8b3ff6b3f445aaf1daa166" => :high_sierra
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
