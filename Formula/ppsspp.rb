class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      :tag => "v1.4.2",
      :revision => "3ae4c122e5131a818ca88c54b1e62a66710d8799"
  revision 1
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    cellar :any
    sha256 "e5d5ddc825bb3af1413ac5d2aee4c31e722901c88c63a64ad237c87aea77c71e" => :sierra
    sha256 "60012173d35870619aa094f78c11143342aab477f595e7be6070daa632a2c227" => :el_capitan
    sha256 "f6f18abb7dd340fa9770bb21f49d137a7033c009d44b5d634a95f2d8d70ed9a8" => :yosemite
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
