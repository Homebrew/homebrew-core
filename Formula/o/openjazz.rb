class Openjazz < Formula
  desc "Open source Jazz Jackrabit engine"
  homepage "https://www.alister.eu/jazz/oj/"
  url "https://github.com/AlisterT/openjazz/archive/refs/tags/20240919.tar.gz"
  sha256 "c50193b630c375840026d729bb9dda6c7210b1523e62d7ae019ce2e37f806627"
  license "GPL-2.0-only"
  head "https://github.com/AlisterT/openjazz.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "0febc2f95efd03671c03ef8ce9687243a2dad0e66009c81005463ffa22590cc7"
    sha256 arm64_sequoia: "a7187b8961dddc281206ef88cda1c3f4a58814d0f55b3d6f526ceb8d3c9db01e"
    sha256 arm64_sonoma:  "1fdf7bc6cc7a1e571240965ef4ba7a404aad892fb358223cfee277d1a0532dd0"
    sha256 arm64_ventura: "d0520016ae1625393667870d16f357d577492da14f0786b68f15e3779e723aaf"
    sha256 sonoma:        "19b1f3221c3f5c2ebd7adfc04a31678e5b977f1ddbdbd8bc7f4a98c547fd21b2"
    sha256 ventura:       "f97fe8756255c753917f6983306e91dd7744e30ad8192b982f661f448c726786"
    sha256 arm64_linux:   "46f6d97acd3a0e936733f28485f168a49827155624ffe4d59e294d48562cb946"
    sha256 x86_64_linux:  "828353e6344b50b4fba0f4603e4f7794495bed782e220186129e1c9d37800daa"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"
  depends_on "sdl2_net"

  uses_from_macos "zlib"

  # From LICENSE.DOC:
  # "Epic MegaGames allows and encourages all bulletin board systems and online
  # services to distribute this game by modem as long as no files are altered
  # or removed."
  resource "shareware" do
    url "https://image.dosgamesarchive.com/games/jazz.zip"
    sha256 "ed025415c0bc5ebc3a41e7a070551bdfdfb0b65b5314241152d8bd31f87c22da"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DDATAPATH=#{pkgshare}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    resource("shareware").stage do
      pkgshare.install Dir["*"]
    end
  end

  def caveats
    <<~EOS
      The shareware version of Jazz Jackrabbit has been installed.
      You can install the full version by copying the game files to:
        #{pkgshare}
    EOS
  end

  test do
    system bin/"OpenJazz", "--version"
    assert_path_exists testpath/"openjazz.log"
  end
end
