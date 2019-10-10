class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      :tag      => "v1.9.3",
      :revision => "bf1777f7d3702e6a0f71c7ec1fc51976e23c2327"
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    cellar :any
    sha256 "44023b7686c2b7d305be47c2ab706891ed41e6d2acc30c0c05e9da452f916631" => :mojave
    sha256 "b9e7eedbd1db8f9b3dafb13d2081a230ded65d59c232ebec0db36cd9d5bfdc22" => :high_sierra
    sha256 "35bc11f99dc63d71d24296412b8c90f2e06a2503ca3fea5fc4e3779dc699c571" => :sierra
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
