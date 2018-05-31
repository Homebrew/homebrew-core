class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      :tag => "v1.6.2",
      :revision => "00e5da2c35639db3a485528396bce4436ea44467"
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    cellar :any
    sha256 "2700cf1ad79f686dab67c9828fdf5e8b8046bf299f409fafccade2e577001289" => :high_sierra
    sha256 "0a84024acc8cc8f8c1d6e73ed1afb6cb099a9c52cc69cef925762a2dee89949a" => :sierra
    sha256 "a9090b51f4fd4126e91202550fc9c77e9dad62011769a79c2b01e5b472500447" => :el_capitan
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
