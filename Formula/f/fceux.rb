class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  stable do
    url "https://github.com/TASEmulators/fceux.git",
        tag:      "v2.6.6",
        revision: "34eb7601c415b81901fd02afbd5cfdc84b5047ac"

    # patch for `New timeStamp.cpp file renders fceux x86-only` issue
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/cd40795/fceux/2.6.6-arm.patch"
      sha256 "0890494f4b5db5fa11b94e418d505cea87dc9b9f55cdc6c97e9b5699aeada4ac"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f19e8cc59d907ac3461882c01b7d6a7e6b740e1bb808e131f03351f437e18137"
    sha256 cellar: :any,                 arm64_ventura:  "ad14c19cee60ac3ff7744574efefbc5f1b79cebbecb59889610897dcdc87e02c"
    sha256 cellar: :any,                 arm64_monterey: "feef0ae851b641755c0ff1b6183e80946bd3af2a585195e1a70b3f4062a2a361"
    sha256 cellar: :any,                 sonoma:         "5bb45a8a6be0636d8a8ff18d5f98c3c6c4c034e4c5badd35d63ae430b61f1141"
    sha256 cellar: :any,                 ventura:        "cf540cf08ebc5b2bd3c4b3b73f03fe993097eb9155cf94cb52acb8c34de362e2"
    sha256 cellar: :any,                 monterey:       "b512fb7f161b6ded4ca25c81b3986777363eb7ceaf5cbabbb74bd9e18ee9bce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "173565783554d7ddc1e65ef4bd515c2418c805a6cc093d5577bdde389c57cc2b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "ffmpeg"
  depends_on "libarchive"
  depends_on "minizip"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "x264"
  depends_on "x265"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib"
  end

  fails_with gcc: "5"

  def install
    ENV["CXXFLAGS"] = "-DPUBLIC_RELEASE=1" if build.stable?
    system "cmake", ".", *std_cmake_args, "-DQT6=ON"
    system "make"
    cp "src/auxlib.lua", "output/luaScripts"
    fceux_path = OS.mac? ? "src/fceux.app/Contents/MacOS" : "src"
    libexec.install Pathname.new(fceux_path)/"fceux"
    pkgshare.install ["output/luaScripts", "output/palettes", "output/tools"]
    (bin/"fceux").write <<~EOS
      #!/bin/bash
      LUA_PATH=#{pkgshare}/luaScripts/?.lua #{libexec}/fceux "$@"
    EOS
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"fceux", "--help"
  end
end
