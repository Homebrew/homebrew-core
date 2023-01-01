class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "http://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.1.0_src.tar.gz"
  sha256 "e37eb6653916b585bd58dea005f56861a613140798d0ed6cb27fe3abd260c4f5"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "eb4e76f3a66ee8f7e61a30d080ab9465d7ef7da64560581b5f991e10f9eda103"
    sha256 cellar: :any,                 arm64_monterey: "4ab04ce023eb482822e6c66db96cc5149156d6a2edf6a890c8a5c8c1d03a526f"
    sha256 cellar: :any,                 arm64_big_sur:  "2e3a57aaa5ac49500f455608f2bf73996925ce835f6682fa20b160a9ca2b2f3b"
    sha256 cellar: :any,                 monterey:       "7885acf47a20f61c4b8fd811558fec5a29770fcc2216f07c836a30e9b2580ab9"
    sha256 cellar: :any,                 big_sur:        "f7834f80f6d6c2a85e733ecceb0f7fc87aa7395aea1f693ed46f545e96a95bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eeb6a02eb6fdd22131c28b16962102049f1136cb45a2aa218d3cbba90a06c949"
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
