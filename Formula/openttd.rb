class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/13.1/openttd-13.1-source.tar.xz"
  sha256 "5edf22d37035238285ef672a97d59e64280bebab23e584780834ccd6be0a58bb"
  license "GPL-2.0-only"
  head "https://github.com/OpenTTD/OpenTTD.git", branch: "master"

  livecheck do
    url "https://cdn.openttd.org/openttd-releases/latest.yaml"
    regex(/version:\s*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d891f728039a478e155475335b3ce05723cbe1634720730a7c109b16578c3de7"
    sha256 cellar: :any, arm64_monterey: "550217e413470ce6de386f333b8592e61cf52a943837dd869fabd09edea2b4a0"
    sha256 cellar: :any, arm64_big_sur:  "29f9ace128d1aaa0bd86567868a00a7a00627f7052982778bbb05ae398e63245"
    sha256 cellar: :any, ventura:        "282146e3015f8ff0293c6c464c6ce183707e70bd7bd46356c20b85be25e564ee"
    sha256 cellar: :any, monterey:       "ba319eace37bdc048acb5865039d74a10e5b8f7b2ab9c914133d98c06b1f8316"
    sha256 cellar: :any, big_sur:        "d2652b8bb690472ad8a2034e07b1ff2fe31227f51b55b932be507232a53956fa"
    sha256               x86_64_linux:   "3e05a78b0a757d9aaeaec8d8f9bc8aeff065cbcb08df0f9c35ddedc65503dd09"
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
