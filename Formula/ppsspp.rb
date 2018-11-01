class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      :tag => "v1.7.1",
      :revision => "fdb07323e0878e4773011a7a51a43a8900ad9d4a"
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    cellar :any
    sha256 "3e003edaf5ba25ab8f2c87d70673534f0d2e79ed1fbeadc7a4a80951630f7619" => :mojave
    sha256 "1a2fc8743a9fbaa0f77836bdd874eaebeb0117af5ca61e99dd9e44a8312f17dc" => :high_sierra
    sha256 "e91b28f7e661e07d9656d94da7fa5aa4bfb1b4c639f7ba363e8e0bfa3d3d0e13" => :sierra
    sha256 "8a21b9cc0971f4d774b915152f487253d1bd7dca062c1f4f8376dd6fac24710f" => :el_capitan
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
