class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/14.1/openttd-14.1-source.tar.xz"
  sha256 "2c14c8f01f44148c4f2c88c169a30abcdb002eb128a92b9adb76baa76b013494"
  license "GPL-2.0-only"
  head "https://github.com/OpenTTD/OpenTTD.git", branch: "master"

  livecheck do
    url "https://cdn.openttd.org/openttd-releases/latest.yaml"
    strategy :yaml do |yaml|
      yaml["latest"]&.map do |item|
        next if item["name"] != "stable"

        item["version"]&.to_s
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1d592d47d07bb7af7c46266ec4e8c398f4e215496d6793dedfdf636b367b88e3"
    sha256 cellar: :any, arm64_ventura:  "bbb3a5562f84cef0943051db9502d831eacaaedcfdb39d1046c4986131dc4eb1"
    sha256 cellar: :any, arm64_monterey: "b3d9ee412a332d9c60734d45e717df2e70ddc113cd7301a2a84a37cc4bbd3e84"
    sha256 cellar: :any, sonoma:         "45bbf6a073ecb8184a1b8486db11f7fae0e826881aad223b6d6c54620967d1f3"
    sha256 cellar: :any, ventura:        "08d719114a5d0bdc0e1a7c0168556bace588a509e68bd1ec0e0b1399f90e6370"
    sha256 cellar: :any, monterey:       "25f8adbd67b0bb7f3403fefb4fc98bc904e4c8cc001c35cd81d771f89a0b61e8"
    sha256               x86_64_linux:   "4c1d2054b9907a1fd298a1b474d641741e36858a214b6c8e518bb25326828a82"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "lzo"
  depends_on macos: :catalina # needs C++20
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
      strategy :yaml do |yaml|
        yaml["latest"]&.map do |item|
          next if item["name"] != "stable"

          item["version"]&.to_s
        end
      end
    end
  end

  resource "openmsx" do
    url "https://cdn.openttd.org/openmsx-releases/0.4.2/openmsx-0.4.2-all.zip"
    sha256 "5a4277a2e62d87f2952ea5020dc20fb2f6ffafdccf9913fbf35ad45ee30ec762"

    livecheck do
      url "https://cdn.openttd.org/openmsx-releases/latest.yaml"
      strategy :yaml do |yaml|
        yaml["latest"]&.map do |item|
          next if item["name"] != "stable"

          item["version"]&.to_s
        end
      end
    end
  end

  resource "opensfx" do
    url "https://cdn.openttd.org/opensfx-releases/1.0.3/opensfx-1.0.3-all.zip"
    sha256 "e0a218b7dd9438e701503b0f84c25a97c1c11b7c2f025323fb19d6db16ef3759"

    livecheck do
      url "https://cdn.openttd.org/opensfx-releases/latest.yaml"
      strategy :yaml do |yaml|
        yaml["latest"]&.map do |item|
          next if item["name"] != "stable"

          item["version"]&.to_s
        end
      end
    end
  end

  def install
    # Disable CMake fixup_bundle to prevent copying dylibs
    inreplace "cmake/PackageBundle.cmake", "fixup_bundle(", "# \\0"
    # Have CMake use our FIND_FRAMEWORK setting
    inreplace "CMakeLists.txt", "set(CMAKE_FIND_FRAMEWORK LAST)", ""

    args = std_cmake_args(find_framework: "FIRST")
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
