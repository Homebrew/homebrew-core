class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "https://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_3.8.2_src.tar.gz"
  sha256 "7abe9b10aa6f683eda279794bc03ee05e1b0b2239e38718860333d35f91b4858"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "73d707de08c1ce389e5403c7f1d664ae75d87493ee8bc0fc0b3830f978219c6d"
    sha256 cellar: :any,                 arm64_big_sur:  "73d707de08c1ce389e5403c7f1d664ae75d87493ee8bc0fc0b3830f978219c6d"
    sha256 cellar: :any,                 monterey:       "942ef1ebe6393fdafacc173b10cedfba80094b547fb0fe1c40fea1de9ab3a87e"
    sha256 cellar: :any,                 big_sur:        "58bca7fa9e3ae2225da6a740640f62272a5242b2f8438a8584071a4bc280b0cd"
    sha256 cellar: :any,                 catalina:       "a7c28f9c58413ddb04a1da6dade0116deebbeb77332ab4e49f471c912ea369b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d6af2f2cd7d3739d6efbb2c24d4739cf22537d49e58b2291f9fb7e962997fe1"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
  depends_on "qt@5"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    # Need to explicitly set up include directories
    ENV.append_to_cflags "-I#{Formula["ffmpeg@4"].opt_include}"

    mkdir "build" do
      qt5 = Formula["qt@5"].opt_prefix
      system "#{qt5}/bin/qmake", "PREFIX=#{prefix}",
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
    user_config_dir = testpath/".pc6001vx"
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
