class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "http://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.1.2_src.tar.gz"
  sha256 "918b7e81026a750d9329027c6875c980bc506091447d7ad402baffd1b662c560"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "649de03f90a9db655b03c52689fc386ccd3dd10e88f3f21241fcfdc274eba318"
    sha256 cellar: :any,                 arm64_monterey: "476c4fc3b81404f38036f02a0eeb4200b32c530c892eacd05408cb64734d5225"
    sha256 cellar: :any,                 arm64_big_sur:  "232b2ba6a248cb7cc72fbb03dab6e4d119f6d73e1d50dbcef5e7a39637cea889"
    sha256 cellar: :any,                 ventura:        "fe152db03a0e1eed77cd1cc2a1dfed0405544695a74c173f5bd0c410702751c0"
    sha256 cellar: :any,                 monterey:       "8b6188c14c9bf5eb3231752ce12130f5f2937912e187ea81031bdd16e516dac5"
    sha256 cellar: :any,                 big_sur:        "a21480c22b0a60062d419a5086432cafc6874cadd99e791d16ddf26334067f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d953826b1cd36e4bcb00aab2ff059b6576255c5f18a5d288ac23c9f25fbcb0bd"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    mkdir "build" do
      system "qmake", "PREFIX=#{prefix}",
                                 "QMAKE_CXXFLAGS=#{ENV.cxxflags}",
                                 "CONFIG+=no_include_pwd",
                                 ".."
      system "make"

      if OS.mac?
        prefix.install "PC6001VX.app"
        bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
      else
        bin.install "PC6001VX"
      end
    end
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "minimal" unless OS.mac?
    user_config_dir = testpath/".pc6001vx4"
    user_config_dir.mkpath
    pid = fork do
      exec bin/"PC6001VX"
    end
    sleep 15
    assert_predicate user_config_dir/"pc6001vx.ini",
                     :exist?, "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end
