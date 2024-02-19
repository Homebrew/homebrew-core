class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  stable do
    url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.2.5_src.tar.gz"
    sha256 "4f44df8940db6d412bf4d316c950c540f03c5ab543b028b793998bfeeaac64ac"

    # backport a fix for incorrectly handling SIGTERM
    patch do
      url "https://github.com/eighttails/PC6001VX/commit/93f2a366d1944237d4712a6de4290ac1bda15771.patch?full_index=1"
      sha256 "f4e9d7f23ec7d0f87d869cfcef84de80f1371cc703600313a00970f84d77c632"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "65dea9e1fbc2308ac2e2dffcaf79b2cf18f564345e87a07bbc56c810150899ff"
    sha256 cellar: :any, arm64_ventura:  "5ecc46cb15241a806a0850625880ca2f480b033ed1e52a4a8aa7c53e9ed522a0"
    sha256 cellar: :any, arm64_monterey: "87288283dc869c461f72796389efc1364dbcef14fbda590531764cd9836fa496"
    sha256 cellar: :any, sonoma:         "215c5be9581f838738d92e21b3a04eaa00013054ba8f15a4572f4e4117cf50f1"
    sha256 cellar: :any, ventura:        "aa9cbcfed113f9d8588be9ba49f39bff59bf315a266cbd47a73a3b98da7b4cc4"
    sha256 cellar: :any, monterey:       "c0fd47cd4c5cdaabe5f6eafb0deb2a3f3201b3c840e102d49be037df22684721"
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

      prefix.install "PC6001VX.app"
      bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
    end
  end

  test do
    # locales aren't set correctly within the testing environment
    ENV["LC_ALL"] = "en_US.UTF-8"
    user_config_dir = testpath/".pc6001vx4"
    user_config_dir.mkpath
    pid = fork do
      exec bin/"PC6001VX"
    end
    sleep 20
    assert_predicate user_config_dir/"rom",
                     :exist?, "User config directory should exist"
  ensure
    # the first SIGTERM signal closes a window which spawns another immediately
    # after 5 seconds, send a second SIGTERM signal to ensure the process is fully stopped
    Process.kill("TERM", pid)
    sleep 5
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
