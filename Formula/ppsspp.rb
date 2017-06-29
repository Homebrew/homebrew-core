class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      :tag => "v1.4.2",
      :revision => "3ae4c122e5131a818ca88c54b1e62a66710d8799"
  revision 2
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    cellar :any
    sha256 "701b8ad9ff662cc58f98e1c6c7922835066a60dee82356bcf23f38bdcfc41817" => :sierra
    sha256 "9f2a6481157ada2529a9edc9979cf698435d35b022cc989741580cbb6b29e9ff" => :el_capitan
    sha256 "c4c8a52e30a248503364381981371fabd3da9e77187dcda54a8e3984a7b329f1" => :yosemite
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
