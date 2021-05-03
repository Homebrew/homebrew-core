class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/1.11.2/openttd-1.11.2-source.tar.xz"
  sha256 "0fba935a2a815f4fe8cd6dc2e2ae33f72769538731228f848a63b3a6e9482e6d"
  license "GPL-2.0-only"
  head "https://github.com/OpenTTD/OpenTTD.git"

  livecheck do
    url :homepage
    regex(/Download stable \((\d+(\.\d+)+)\)/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "31ae2ed8dcd5b4c33d8f49cbe2827b99de23788b820f787ef6c1b3c0f6f0786e"
    sha256 cellar: :any, catalina: "f26ba56a9169739aa89d97ab3cb6f9fdf9c230cd8464fe75adf0bc84a05d6376"
    sha256 cellar: :any, mojave:   "38b60732cd3ad6df673a6760a9a6d0d3b58dac3b4dbd7cf19cb275026e0e3c1e"
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

  resource "openmsx" do
    url "https://cdn.openttd.org/openmsx-releases/0.4.0/openmsx-0.4.0-all.zip"
    sha256 "7698cadf06c44fb5e847a5773a22a4a1ea4fc0cf45664181254656f9e1b27ee2"
  end

  resource "opensfx" do
    url "https://cdn.openttd.org/opensfx-releases/1.0.1/opensfx-1.0.1-all.zip"
    sha256 "37b825426f1d690960313414423342733520d08916f512f30f7aaf30910a36c5"
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
