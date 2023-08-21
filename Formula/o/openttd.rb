class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/13.4/openttd-13.4-source.tar.xz"
  sha256 "2a1deba01bfe58e2188879f450c3fa4f3819271ab49bf348dd66545f040d146f"
  license "GPL-2.0-only"
  head "https://github.com/OpenTTD/OpenTTD.git", branch: "master"

  livecheck do
    url "https://cdn.openttd.org/openttd-releases/latest.yaml"
    regex(/version:\s*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32f2e7021a484af00d0d5884864d35d83d0f8a67831ca2ba02966b0970bf43c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48610f296bb2633b043e2a623e8503ed59b67867469c502a4a0c3d5b34561c79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea285a23cd2736976db458c96132be25391bef4c563285e5653371674c002e54"
    sha256 cellar: :any_skip_relocation, ventura:        "35830f4068b0bd0b789162ca0c85c16d67b17605ed6a7d714f6b11a1a4deefe2"
    sha256 cellar: :any_skip_relocation, monterey:       "4a45055d7982167909e1e97e1e1858330b16c06489a02b825e6a525227ed76e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f23a6a378b56e2c4116ffc0246ce322a5bbe45c254451a67566e5b8f034cac9"
    sha256                               x86_64_linux:   "ebd05557f82edd927eb5820578036e1299c731dc8eadedbbe03e6d11a5a6cac3"
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
        (pkgshare/"baseset"/r.name).install r
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
