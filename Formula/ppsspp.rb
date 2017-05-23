class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      :tag => "v1.4.1",
      :revision => "e776eff6dba97df3b742dd7e178d2aaf9b15cc87"
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    cellar :any
    sha256 "69350600edc8ac7d5199ff18e58a51509a3b17ec90198787d51f2d600202ffc0" => :sierra
    sha256 "d55fb7fa77881645d9d84d70c1558c8445dd4fbec33db8daba445ad37aaff6dd" => :el_capitan
    sha256 "f5e717573e1b9d0f54d30f13ee288445c001db65b352f66edd665039f41ea611" => :yosemite
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
