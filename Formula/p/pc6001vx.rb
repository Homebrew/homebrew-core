class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  license "LGPL-2.1-or-later"
  revision 2
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
    sha256 cellar: :any, arm64_sonoma:   "d9f0c85994080637e87e46e657c1fa0a585d69d74548a2305654dd9a1f545e08"
    sha256 cellar: :any, arm64_ventura:  "1e8a92b9a880400821197103bb6571997b468e1bc2777c80d6b7a4c0d8233370"
    sha256 cellar: :any, arm64_monterey: "6931561bcb1b2bf2b3f56cc24867458dc96bb79e7dd1305fa3f4becf77088b9d"
    sha256 cellar: :any, sonoma:         "c86a325c279e134b003bfac3483aac49d8d7202ec90e774bcacc4cede9fc8d93"
    sha256 cellar: :any, ventura:        "5f87fb22702196d38f976a764a970ae4bfee3b394a3b5090e0aaacf2500985ba"
    sha256 cellar: :any, monterey:       "dc8fdc3a168a600b1f98a40c03d8b2032a3f3cee6eb18974cd9c738ce55838ce"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg@6"
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
    sleep 30
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
