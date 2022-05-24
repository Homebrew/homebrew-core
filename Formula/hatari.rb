class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://hatari.tuxfamily.org"
  url "https://download.tuxfamily.org/hatari/2.3.1/hatari-2.3.1.tar.bz2"
  sha256 "44a2f62ca995e38d9e0874806956f0b9c3cc84ea89e0169a63849b63cd3b64bd"
  license "GPL-2.0-or-later"
  revision 1
  head "https://git.tuxfamily.org/hatari/hatari.git", branch: "master"

  livecheck do
    url "https://download.tuxfamily.org/hatari/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5f31dc6f5ac2f5a7785841b8a1bf2cd61bf6f61655392ebc1fe326424d490216"
    sha256 cellar: :any,                 arm64_big_sur:  "5733267d71db6559a05fb67249929ea882614d8b318e4ae5d68362d8193aceb4"
    sha256 cellar: :any,                 monterey:       "3fe0d58f4ff6cc654d25ddf53fbf76a1035960403dfd3e67f4b99da0491dc2c9"
    sha256 cellar: :any,                 big_sur:        "b5d322e4d68cd6e8b65432fedfb2f5807b66bb7ebce9a9faba97e846fd9d73fe"
    sha256 cellar: :any,                 catalina:       "aa1ad23ac7d636cb1702461d1eb6ecb2ec5df195a10bfbffcaa036db8f3b3c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21c89b23ed14051eecf598ce07ec906f46910ee00145b3275708421fe94e463a"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "portaudio"
  depends_on "python@3.10"
  depends_on "sdl2"

  # Download EmuTOS ROM image
  resource "emutos" do
    url "https://downloads.sourceforge.net/project/emutos/emutos/1.0.1/emutos-512k-1.0.1.zip"
    sha256 "96c698aa0fc0f51ecdb0f8b53484df9de273215467b5de3f44d245821dff795e"
  end

  def install
    # Set .app bundle destination
    inreplace "src/CMakeLists.txt", "/Applications", prefix
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
      "-DPYTHON_EXECUTABLE=#{Formula["python@3.10"].opt_bin}/python3"
    system "cmake", "--build", "build"
    if OS.mac?
      prefix.install "build/src/Hatari.app"
      bin.write_exec_script "#{prefix}/Hatari.app/Contents/MacOS/hatari"
    else
      system "cmake", "--install", "build"
    end
    resource("emutos").stage do
      if OS.mac?
        (prefix/"Hatari.app/Contents/Resources").install "etos512k.img" => "tos.img"
      else
        pkgshare.install "etos512k.img" => "tos.img"
      end
    end
  end

  test do
    assert_match "Hatari v#{version} -", shell_output("#{bin}/hatari -v", 1)
  end
end
