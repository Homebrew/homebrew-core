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
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "c0474c89956d999fcdf65ffabc20acc891fe6f553f68dc2dae121e9b1bef8e62"
    sha256 cellar: :any, arm64_monterey: "b7634c8226eefa527c8c18889b2a1493df76145f81004d137186ff60bc61cefb"
    sha256 cellar: :any, arm64_big_sur:  "59a846aef200324ba4df723fe712c5dfaa4044f01d34b328839c30ea5b52fb0f"
    sha256 cellar: :any, ventura:        "8af1ad5e427dbaa1d6068d5deb1af289a7b80ae0cbd8336cbf86ee99a3e705eb"
    sha256 cellar: :any, monterey:       "686298b62aca61f3215eacca71a457e35c0cb439d334a08a625ce096268cd998"
    sha256 cellar: :any, big_sur:        "c1ec943c89316af06939cf7e55e9f2d5aa9eb46ad95f91c9d104acbd85dd5b75"
    sha256 cellar: :any, catalina:       "a884b8a01baef4a90209053ab7ffbae294045afe33273c0b14d04c14640a6f33"
    sha256               x86_64_linux:   "2629dd5ea308d530b4864cf2c3db1f54c68dda1b171189b1d13f8386e81ee958"
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
