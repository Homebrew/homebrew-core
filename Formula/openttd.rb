class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/12.2/openttd-12.2-source.tar.xz"
  sha256 "81508f0de93a0c264b216ef56a05f8381fff7bffa6d010121a21490b4dace95c"
  license "GPL-2.0-only"
  head "https://github.com/OpenTTD/OpenTTD.git", branch: "master"

  livecheck do
    url :homepage
    regex(/Download stable \((\d+(\.\d+)+)\)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "c8e7924e6b8f1d3fc32c777ab3ab4b2ab1bffbca6d599497560b13799a389661"
    sha256 cellar: :any, arm64_big_sur:  "c7772367d985f9981bee4069208a958a398aab61923d9fd02f03b2a0c2926705"
    sha256 cellar: :any, monterey:       "3331f8d0d63db46dac47418043e24f29c6431fa071f9da5a97103a1464a0787d"
    sha256 cellar: :any, big_sur:        "9f9ff69db98080b7ae62828f639055b5e2b7bbd750271fee2d037e2ac8fa5884"
    sha256 cellar: :any, catalina:       "7d90dc5a119ce92be9347385e872ce40befc6ba68ff0ddf5c7f22caed55e26b6"
    sha256               x86_64_linux:   "3dfbf841157447caddfb874da41cd9ca806d3b96ce54380b16e085e910f2c74f"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "lzo"
  depends_on macos: :high_sierra # needs C++17
  depends_on "xz"

  on_linux do
    depends_on "fluid-synth"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gcc"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "sdl2"
  end

  fails_with gcc: "5"

  resource "opengfx" do
    url "https://cdn.openttd.org/opengfx-releases/7.1/opengfx-7.1-all.zip"
    sha256 "928fcf34efd0719a3560cbab6821d71ce686b6315e8825360fba87a7a94d7846"
  end

  resource "openmsx" do
    url "https://cdn.openttd.org/openmsx-releases/0.4.2/openmsx-0.4.2-all.zip"
    sha256 "5a4277a2e62d87f2952ea5020dc20fb2f6ffafdccf9913fbf35ad45ee30ec762"
  end

  resource "opensfx" do
    url "https://cdn.openttd.org/opensfx-releases/1.0.3/opensfx-1.0.3-all.zip"
    sha256 "e0a218b7dd9438e701503b0f84c25a97c1c11b7c2f025323fb19d6db16ef3759"
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
