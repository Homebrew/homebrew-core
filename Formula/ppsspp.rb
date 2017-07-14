class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      :tag => "v1.4.2",
      :revision => "3ae4c122e5131a818ca88c54b1e62a66710d8799"
  revision 3
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    cellar :any
    sha256 "1bc9e5765a517bd1c46555ffe101f9e822e43faee243f8d0ee6e0976c23fa266" => :sierra
    sha256 "4c81a521f9d6319403eb21b56b72bc16f7bcadcf124fe92e29b881166199330a" => :el_capitan
    sha256 "5a9a50933e5e774fb56788fb36247ce415e5b584cfec4aade3648a5559cb8d31" => :yosemite
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
