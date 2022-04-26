class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.0",
      revision: "c6302a1dae09e2539ed053390ca0dd1816448a14"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fade49a67c3c4e6482c26920a22cce14584f3e113c4ff3bfb97b3c7ad75c53c4"
    sha256 cellar: :any,                 arm64_big_sur:  "f7d54d7a4f15a2472532403a3dd90414d6a82c77494fadf3110208b0f04c34dc"
    sha256 cellar: :any,                 monterey:       "a24dfca95a0553fb0aba91d3667d8f95b195b5ac3035183f6dbb52a333f28979"
    sha256 cellar: :any,                 big_sur:        "8c7bee97db5f9455da1dedd0048b9ed24b0738e1975e8ea5baa6e2438e00e715"
    sha256 cellar: :any,                 catalina:       "74e498408e5802c10e5dd776223011d08811b943aacfab11faff88a1d8bde7f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1515ae1da051676328ae5bf59cf0d627677e5440e976c33b49a40fae3c7f7b97"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkg-config" => :build
  depends_on "duktape"
  depends_on "freetype"
  depends_on "icu4c"
  depends_on "libpng"
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
    url "https://github.com/OpenRCT2/objects/archive/v1.2.7.tar.gz"
    sha256 "ec9a4f862365477b24a9eea16159131b235e05330fa2becefa1a113b17e6bceb"
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
