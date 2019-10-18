class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      :tag      => "v1.9.4",
      :revision => "e3c9793cb3a68ec9f44371c7ebb45a0abed1ecca"
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    cellar :any
    sha256 "d75bb2be7c06f4b263f4838fea69f088ff250dafa4cacbf04539f2592c2943fc" => :catalina
    sha256 "187d2012465b3fbd98c31d8740fee3628bd0e43999a20745e52e4f0f56b3c305" => :mojave
    sha256 "fb440ce88897975c12356f815c548ea7c6f36f1a8ab35775ba63fbb4d2ee8f07" => :high_sierra
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
