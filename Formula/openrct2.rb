class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.4",
      revision: "9e4918cdbc3a90f3da0373fc824f675d9332d3f6"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "409295cd72ee4a37053153c077916c1788877963d126285fb3df0608ef8552b6"
    sha256 cellar: :any, arm64_monterey: "374ab18c18e2fc3aa218566c14254f9991c581d148cfb46677efebf6c2857840"
    sha256 cellar: :any, arm64_big_sur:  "8223d770906d95a8d4b020c743e1f7be1d81f336e4d624191c5c2206e545c343"
    sha256 cellar: :any, ventura:        "b222c11b74f412b7df1570fc31a00bbf70eb31b78d3bbc1c6991c47226b63b62"
    sha256 cellar: :any, monterey:       "78a743b962b1507dcdf23efb159e6d6277b2b0c0fc5d7766599374364a757247"
    sha256 cellar: :any, big_sur:        "e3f0f414820ac845b5a640671415025f6b3c76ad42071520143123eed9e77a2c"
    sha256               x86_64_linux:   "8f2c2d34e23b9a2c15c82a236caec6c4255e0c846b7f2d8d2615c53c63fb1352"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkg-config" => :build
  depends_on "duktape"
  depends_on "flac"
  depends_on "freetype"
  depends_on "icu4c"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on macos: :mojave # `error: call to unavailable member function 'value': introduced in macOS 10.14`
  depends_on "openssl@1.1"
  depends_on "sdl2"
  depends_on "speexdsp"

  on_linux do
    depends_on "curl"
    depends_on "fontconfig"
    depends_on "mesa"
  end

  fails_with gcc: "5" # C++17

  resource "title-sequences" do
    url "https://github.com/OpenRCT2/title-sequences/releases/download/v0.4.0/title-sequences.zip"
    sha256 "6e7c7b554717072bfc7acb96fd0101dc8e7f0ea0ea316367a05c2e92950c9029"
  end

  resource "objects" do
    url "https://github.com/OpenRCT2/objects/releases/download/v1.3.8/objects.zip"
    sha256 "84a95590d13a753b1d239f7f06c8d121e36fd28694b21f33646518e2012904ae"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath/"data/title").install resource("title-sequences")
    (buildpath/"data/object").install resource("objects")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}",
                            "-DWITH_TESTS=OFF",
                            "-DDOWNLOAD_TITLE_SEQUENCES=OFF",
                            "-DDOWNLOAD_OBJECTS=OFF",
                            "-DMACOS_USE_DEPENDENCIES=OFF",
                            "-DDISABLE_DISCORD_RPC=ON"
      system "make", "install"
    end

    # By default macOS build only looks up data in app bundle Resources
    libexec.install bin/"openrct2"
    (bin/"openrct2").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/openrct2" "$@" "--openrct2-data-path=#{pkgshare}"
    EOS
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}/openrct2 -v")
  end
end
