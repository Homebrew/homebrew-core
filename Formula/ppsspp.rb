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
    sha256 "7c4bbf7f57fd8cd710ad9bbc8090517b5ed3916747a2ce39e6bda29211737da9" => :sierra
    sha256 "8b0ffae31763e4dbaf6f517bc9de51d081133ee57e50c86f7b97d73f01cbcfb8" => :el_capitan
    sha256 "bc764d898982dcbea9a11bd8b10863faa5e0f1fcbe494e581b058ce856f25616" => :yosemite
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
