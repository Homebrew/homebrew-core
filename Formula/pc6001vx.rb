class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "https://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_3.8.2_src.tar.gz"
  sha256 "7abe9b10aa6f683eda279794bc03ee05e1b0b2239e38718860333d35f91b4858"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "aee07f4792310c51d12c85a460ec600468169c9b584c47f56b1980ef1ad2ab25"
    sha256 cellar: :any, big_sur:       "955a851714857a6316552a47e4456f1767c0031da42eb639f3bd256881f19633"
    sha256 cellar: :any, catalina:      "26437cbcb26ef046a957c42c6a3a2ba1c35ddd35680efb1c9bbeecdf628574ab"
    sha256 cellar: :any, mojave:        "84e0986b4d0db0802f75ed155e18b2fcf8305707ad031696179a51d28c2ff7b5"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt@5"

  def install
    # Need to explicitly set up include directories
    ENV.append_to_cflags "-I#{Formula["ffmpeg"].opt_include}"

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
