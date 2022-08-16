class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://hatari.tuxfamily.org"
  url "https://download.tuxfamily.org/hatari/2.4.0/hatari-2.4.0.tar.bz2"
  sha256 "3e481b08c45cb65d3423157c4e912b458cb72941ff52478362f9abd791cb1ed7"
  license "GPL-2.0-or-later"
  head "https://git.tuxfamily.org/hatari/hatari.git", branch: "master"

  livecheck do
    url "https://download.tuxfamily.org/hatari/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c06e890d2394881928464a0b1971435718c74d85b137c454584818b2e2b1602d"
    sha256 cellar: :any,                 arm64_big_sur:  "bb29f06d437119578fd81eb5cc7ab183963d071d4f55ea271d9c2e8138021f6c"
    sha256 cellar: :any,                 monterey:       "f9048246704e86815b697a7604544e24756a65b0a53f088ecc4e869ff93fcfc3"
    sha256 cellar: :any,                 big_sur:        "59caa9c5956791e1387d3b15058285a2f846e06edaf08dfb1f63f0f0cac91658"
    sha256 cellar: :any,                 catalina:       "e6d837926d97765a388b6d99cbd030e84dedb9f77f6eb9847a6bea69d206fbe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3103b9d18de3861989ce924bffb46c8722e9dd4f16d0d5c42e0b13926c6aa59"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "python@3.10"
  depends_on "sdl2"

  # Download EmuTOS ROM image
  resource "emutos" do
    url "https://downloads.sourceforge.net/project/emutos/emutos/1.2/emutos-1024k-1.2.zip"
    sha256 "65933ffcda6cba87ab013b5e799c3a0896b9a7cb2b477032f88f091ab8578b2a"
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
        (prefix/"Hatari.app/Contents/Resources").install "etos1024k.img" => "tos.img"
      else
        pkgshare.install "etos1024k.img" => "tos.img"
      end
    end
  end

  test do
    assert_match "Hatari v#{version} -", shell_output("#{bin}/hatari -v", 1)
  end
end
