class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  license "GPL-2.0-only"
  revision 7
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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6cc28629e3494597032119b68b9ac16f4dbdb15920e72776e5b2d9b6c5d4ebd3"
    sha256 cellar: :any,                 arm64_sequoia: "6ffd230662c648ff207944d0f19bcdf16b0a4c0c64886cbe10e9ab82f3ce33a4"
    sha256 cellar: :any,                 arm64_sonoma:  "4bf00f6d14302b29943e393cd1fa29f05cf0fc8648855689a23e744008dda54f"
    sha256 cellar: :any,                 arm64_ventura: "42009a33f97c7ced6c2f73ac8dee97309021c05df3291c139ba22d9f00cfa414"
    sha256 cellar: :any,                 sonoma:        "768b9576ea9e0126862aaca7f8ca87aa3cd59d20450b1731e32c25ccc974637c"
    sha256 cellar: :any,                 ventura:       "5a35b23ff1fcd66ffa5fe52ee0fa193434de77190fe85335ef1c980c9d5fd559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e827f4a19e8ba53022fcb6852717f78a1d3273217d20a06254629ba63cff0d4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

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

  def install
    ENV["CXXFLAGS"] = "-DPUBLIC_RELEASE=1" if build.stable?
    system "cmake", ".", *std_cmake_args, "-DQT6=ON"
    system "make"
    cp "src/auxlib.lua", "output/luaScripts"
    fceux_path = OS.mac? ? "src/fceux.app/Contents/MacOS" : "src"
    libexec.install Pathname.new(fceux_path)/"fceux"
    pkgshare.install ["output/luaScripts", "output/palettes", "output/tools"]
    (bin/"fceux").write <<~BASH
      #!/bin/bash
      LUA_PATH=#{pkgshare}/luaScripts/?.lua #{libexec}/fceux "$@"
    BASH
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"fceux", "--help"
  end
end
