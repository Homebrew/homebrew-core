class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      :tag      => "v1.9.3",
      :revision => "bf1777f7d3702e6a0f71c7ec1fc51976e23c2327"
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    cellar :any
    sha256 "1ea4935c66ea59b4e24fbf9c2bfac1aa865b28e8deb6a734a9ca94b923078576" => :catalina
    sha256 "0f77867a6355432564d6221643a52ee1c181f28f25fec3c8f253cdad274e4ebb" => :mojave
    sha256 "9d8d48a3e033145651c365953225b8e1c83afa0ae15d67aeb03ecdf280be630f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "glew"
  depends_on "libzip"
  depends_on "sdl2"
  depends_on "snappy"

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
