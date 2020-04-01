class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/1.10.0/openttd-1.10.0-source.tar.xz"
  sha256 "1ba21aac9a1de98b23f80fee952b4b9c5e2d3cc4ac187f5203730826b3f0e253"
  head "https://github.com/OpenTTD/OpenTTD.git"

  bottle do
    cellar :any
    sha256 "3b35f09093139d3d7ea20f306ec456fe593fe3af9cbe7c877293494d25602bb5" => :catalina
    sha256 "c225e23880d9ff76ce890180247590f9f9762a61d75ae7cce9785a0a6fe55ead" => :mojave
    sha256 "e176e4b9047426b5bc1ff28a6ba8d979cca9c5f04c5364e1ee59795bec32c1d4" => :high_sierra
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
    assert_match /OpenTTD #{version}\n/, shell_output("#{bin}/openttd -h")
  end
end
