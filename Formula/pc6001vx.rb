class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "http://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.1.3_src.tar.gz"
  sha256 "264f135ad89f443b8b103169ca28e95ba488f2ce627c6dc3791e0230587be0d9"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5fe56ece2e82cd70e36d5d1978f5c7fd3bbe469eda65a1e3844ce8aa3264fc7d"
    sha256 cellar: :any,                 arm64_monterey: "4df3836726afd9ac5a3764e8c115844db0d397f96e5cc8aa613b82e1b83672ba"
    sha256 cellar: :any,                 arm64_big_sur:  "440c0c7aa95cbc7e63d2f3d370e4226c98d39e51ffc69e07e83ba60c7ad6d4e2"
    sha256 cellar: :any,                 ventura:        "7647c70c0a0a5a4b76883369542bc76d49397a6d717d405ef0aff873d5e8bb16"
    sha256 cellar: :any,                 monterey:       "54effdee724677328e2a9fe18a0f0f62788b62088d3c7d5e1c3fa041e65b2da6"
    sha256 cellar: :any,                 big_sur:        "4e7dc9dcbf9dac74c2712e8b150b60a6af82822fa2ffac6a1f78056414c629e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf0763bd9d42ee1318860f5e0cf3bd0a2108fea858fe9eeeb87456e9589d3b06"
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
