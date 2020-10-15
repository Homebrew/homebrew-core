class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/1.10.3/openttd-1.10.3-source.tar.xz"
  sha256 "c11601ef547eb1f6d4f9a035bd19e0a760b47872ce7d9b4117aaa45ac377b53b"
  license "GPL-2.0"
  head "https://github.com/OpenTTD/OpenTTD.git"

  livecheck do
    url :homepage
    regex(/Download stable \((\d+(\.\d+)+)\)/i)
  end

  bottle do
    cellar :any
    sha256 "7958e9cf2b4ee62147a364893c4e2388f7a8e9ab95b2cd54fed6715da60c5be6" => :catalina
    sha256 "e8a6fba720e5ec6ef08f5255fe47a86b271b7f3f45ea8e2a13fd3b277f6eb754" => :mojave
    sha256 "853c329ff51f9ef5403b581911790ba6179bea0cb274b58fb08ac8af0b5aa361" => :high_sierra
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
