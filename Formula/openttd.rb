class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/1.11.0/openttd-1.11.0-source.tar.xz"
  sha256 "5e65184e07368ba1afa62dbb3e35abaee6c4da6730ff4bc9eb4447d53363c7a8"
  license "GPL-2.0-only"
  head "https://github.com/OpenTTD/OpenTTD.git"

  livecheck do
    url :homepage
    regex(/Download stable \((\d+(\.\d+)+)\)/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:     "406f8ff7bf25785ecb8dc062ceabc1ddf33ff8e24b745adb6c7886b17fb74e43"
    sha256 cellar: :any, catalina:    "7958e9cf2b4ee62147a364893c4e2388f7a8e9ab95b2cd54fed6715da60c5be6"
    sha256 cellar: :any, mojave:      "e8a6fba720e5ec6ef08f5255fe47a86b271b7f3f45ea8e2a13fd3b277f6eb754"
    sha256 cellar: :any, high_sierra: "853c329ff51f9ef5403b581911790ba6179bea0cb274b58fb08ac8af0b5aa361"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "lzo"
  depends_on macos: :high_sierra # needs C++17
  depends_on "xz"

  resource "opengfx" do
    url "https://cdn.openttd.org/opengfx-releases/0.6.1/opengfx-0.6.1-all.zip"
    sha256 "c694a112cd508d9c8fdad1b92bde05e7c48b14d66bad0c3999e443367437e37e"
  end

  resource "opensfx" do
    url "https://cdn.openttd.org/opensfx-releases/1.0.1/opensfx-1.0.1-all.zip"
    sha256 "37b825426f1d690960313414423342733520d08916f512f30f7aaf30910a36c5"
  end

  resource "openmsx" do
    url "https://cdn.openttd.org/openmsx-releases/0.4.0/openmsx-0.4.0-all.zip"
    sha256 "7698cadf06c44fb5e847a5773a22a4a1ea4fc0cf45664181254656f9e1b27ee2"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "cpack || :"
    end

    app = "build/_CPack_Packages/amd64/Bundle/openttd-#{version}-macos-amd64/OpenTTD.app"
    resources.each do |r|
      (buildpath/"#{app}/Contents/Resources/baseset/#{r.name}").install r
    end
    prefix.install app
    bin.write_exec_script "#{prefix}/OpenTTD.app/Contents/MacOS/openttd"
  end

  test do
    assert_match "OpenTTD #{version}\n", shell_output("#{bin}/openttd -h")
  end
end
