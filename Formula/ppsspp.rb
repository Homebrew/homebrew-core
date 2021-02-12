class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      tag:      "v1.11.1",
      revision: "d1c4b86e0a5cfa0880ed97f4a08ee2fa2fb01944"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "aadd439c9379c19f33f99ba1045e0e44853e02574bb6819eae421154be55c593"
    sha256 cellar: :any, big_sur:       "c7619f3f55dbbd1f13810db371cf33fe05eb2de536fa59042bd7ffd1899afd7b"
    sha256 cellar: :any, catalina:      "4cc7fc966db279c3a5caefa7b4058023945bb2066340afc651ad4b1baabc6e4a"
    sha256 cellar: :any, mojave:        "2f2e9c6e8145c835e2f001ca11f4bfc2c5e5a243a6bcb63ad6100fbe607f32d7"
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
