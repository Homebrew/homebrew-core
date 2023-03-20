class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/13.0/openttd-13.0-source.tar.xz"
  sha256 "339df8e0e0827087c83afe78f8efc6a73b0a3d8a950a0b53137ce6e8aad7ab67"
  license "GPL-2.0-only"
  head "https://github.com/OpenTTD/OpenTTD.git", branch: "master"

  livecheck do
    url "https://cdn.openttd.org/openttd-releases/latest.yaml"
    regex(/version:\s*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "3fd9ed8230501fc490d3a27206a1e6e4d49d006582e29870b99bea3f7e70d86c"
    sha256 cellar: :any, arm64_monterey: "14b6c29186501cfb8d3eea996d3d3bf4ad6c706e779980a837b06e1fd7e6d4ab"
    sha256 cellar: :any, arm64_big_sur:  "f0e798414d9347466d8577497ade5d63f617ffa547a2cee74039b9e6766c967a"
    sha256 cellar: :any, ventura:        "e1261566af66651482c25fb6e34bc205b27f64db906538880d091a77d1ea563f"
    sha256 cellar: :any, monterey:       "bcede2400fb917438083607e7150c483445d54e740743de2cd6441ac603e0852"
    sha256 cellar: :any, big_sur:        "d3194b95f8f51bbffe198bd91e32187441a6d8fe9ae5cc1ddc74256dac893f83"
    sha256               x86_64_linux:   "732c3de62d746309b2b5e3dca9ef8f60b6d9a801345a5282ec16f9f7a9618856"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "lzo"
  depends_on macos: :high_sierra # needs C++17
  depends_on "xz"

  uses_from_macos "zlib"

  on_linux do
    depends_on "fluid-synth"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "icu4c"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "sdl2"
  end

  fails_with gcc: "5"

  resource "opengfx" do
    url "https://cdn.openttd.org/opengfx-releases/7.1/opengfx-7.1-all.zip"
    sha256 "928fcf34efd0719a3560cbab6821d71ce686b6315e8825360fba87a7a94d7846"

    livecheck do
      url "https://cdn.openttd.org/opengfx-releases/latest.yaml"
      regex(/version:\s*?v?(\d+(?:\.\d+)+)/i)
    end
  end

  resource "openmsx" do
    url "https://cdn.openttd.org/openmsx-releases/0.4.2/openmsx-0.4.2-all.zip"
    sha256 "5a4277a2e62d87f2952ea5020dc20fb2f6ffafdccf9913fbf35ad45ee30ec762"

    livecheck do
      url "https://cdn.openttd.org/openmsx-releases/latest.yaml"
      regex(/version:\s*?v?(\d+(?:\.\d+)+)/i)
    end
  end

  resource "opensfx" do
    url "https://cdn.openttd.org/opensfx-releases/1.0.3/opensfx-1.0.3-all.zip"
    sha256 "e0a218b7dd9438e701503b0f84c25a97c1c11b7c2f025323fb19d6db16ef3759"

    livecheck do
      url "https://cdn.openttd.org/opensfx-releases/latest.yaml"
      regex(/version:\s*?v?(\d+(?:\.\d+)+)/i)
    end
  end

  def install
    # Disable CMake fixup_bundle to prevent copying dylibs
    inreplace "cmake/PackageBundle.cmake", "fixup_bundle(", "# \\0"

    args = std_cmake_args
    unless OS.mac?
      args << "-DCMAKE_INSTALL_BINDIR=bin"
      args << "-DCMAKE_INSTALL_DATADIR=#{share}"
    end

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    if OS.mac?
      cd "build" do
        system "cpack || :"
      end
    else
      system "cmake", "--install", "build"
    end

    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    app = "build/_CPack_Packages/#{arch}/Bundle/openttd-#{version}-macos-#{arch}/OpenTTD.app"
    resources.each do |r|
      if OS.mac?
        (buildpath/"#{app}/Contents/Resources/baseset/#{r.name}").install r
      else
        (share/"openttd/baseset"/r.name).install r
      end
    end

    if OS.mac?
      prefix.install app
      bin.write_exec_script "#{prefix}/OpenTTD.app/Contents/MacOS/openttd"
    end
  end

  test do
    assert_match "OpenTTD #{version}\n", shell_output("#{bin}/openttd -h")
  end
end
