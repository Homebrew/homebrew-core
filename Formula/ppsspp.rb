class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      :tag => "v1.5.1",
      :revision => "e9303fd1cdf8490f2cc56d201b25480538366c1f"
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    cellar :any
    sha256 "12b1eeaa7f1af24c9cb890752cec4a1c5780e5aaf5a1d6c9197832240e46d9d3" => :high_sierra
    sha256 "9ac8b7cdebd3383d57729af3632f14ada8916044ec323ee5d37e7019f04cee1d" => :sierra
    sha256 "f0336b16da129471ecabb39c345831606e7debd6d730d2e59ef895431051f629" => :el_capitan
    sha256 "5af87bf1ef46049413d62f8dc2745911096408dbfe201acee86d64e2d39739ad" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "glew"
  depends_on "libzip"
  depends_on "snappy"
  depends_on "ffmpeg"

  def install
    args = std_cmake_args
    # Use brewed FFmpeg rather than precompiled binaries in the repo
    args << "-DUSE_SYSTEM_FFMPEG=ON"

    # fix missing include for zipconf.h
    ENV.append_to_cflags "-I#{Formula["libzip"].opt_prefix}/lib/libzip/include"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      prefix.install "PPSSPPSDL.app"
      bin.write_exec_script "#{prefix}/PPSSPPSDL.app/Contents/MacOS/PPSSPPSDL"
      mv "#{bin}/PPSSPPSDL", "#{bin}/ppsspp"
    end
  end
end
