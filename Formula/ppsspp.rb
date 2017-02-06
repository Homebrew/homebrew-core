class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "http://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      :tag => "v1.3",
      :revision => "6d0d36bf914a3f5373627a362d65facdcfbbfe5f"
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    cellar :any
    sha256 "c4577b4731eabf5ea07c74d810369d04370765f5fb17fd6690af27f29f4f0320" => :sierra
    sha256 "f0abb71427667e2adac3bc48872602622e16470543b5ef5a37b284b38e527dec" => :el_capitan
    sha256 "a9ba99b5a33144f81bbcec6d411c1186d681628cc32954405003554bd34d9c41" => :yosemite
  end

  depends_on "cmake" => :build
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
