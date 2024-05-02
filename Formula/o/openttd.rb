class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/14.0/openttd-14.0-source.tar.xz"
  sha256 "96f76ab858816a5e30038ade0692e6ebf350b9f70bf19c7b48dda845c88418b1"
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
    sha256 cellar: :any, arm64_sonoma:   "afce71532d6b345243bdd9dcd4d2f1dc3dc7426ab930da748e3feb38113e0a69"
    sha256 cellar: :any, arm64_ventura:  "a5510037d38de6a4192a95b4d58c2ce38dfb636d10676dc099fc439b844d5ba3"
    sha256 cellar: :any, arm64_monterey: "ed843fdfa0932af3849f3bbe387c298b93c0ddc1ac150204b25cb5252253998f"
    sha256 cellar: :any, sonoma:         "12a88c75c1163fc8dbce1c50ab41393548164d930e83c4c83adf0f91bdbb4262"
    sha256 cellar: :any, ventura:        "29bcabf767d0c400e13a40b1121a57fa228e0a881b1572a6a6e66d2d830678e0"
    sha256 cellar: :any, monterey:       "fd06f19dedc38210230e783bdfd889ffa0077e5f4a42c12a16825302219871b1"
    sha256               x86_64_linux:   "b3f9d5ec7cb06b531713841eea437e3df5a986c0311096a096987ae221472079"
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
