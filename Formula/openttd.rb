class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/1.11.2/openttd-1.11.2-source.tar.xz"
  sha256 "0fba935a2a815f4fe8cd6dc2e2ae33f72769538731228f848a63b3a6e9482e6d"
  license "GPL-2.0-only"
  head "https://github.com/OpenTTD/OpenTTD.git", branch: "master"

  livecheck do
    url :homepage
    regex(/Download stable \((\d+(\.\d+)+)\)/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "b6622b443f75f7e3a1ffe8934126abb27015ee411760d8da877915e7510ba87f"
    sha256 cellar: :any, catalina: "8fcdb977e1c8cccd09f58e76ed7f5d8da68ae4920a1663942eb7254f96acfe7b"
    sha256 cellar: :any, mojave:   "e319820fb6a08d4d1f7a3ed255c3ba11285aeca31c15d6a9743c0c24830900e1"
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
