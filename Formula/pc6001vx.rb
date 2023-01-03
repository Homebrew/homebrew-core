class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "http://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.1.0_src.tar.gz"
  sha256 "e37eb6653916b585bd58dea005f56861a613140798d0ed6cb27fe3abd260c4f5"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "24155252dc8d0f4b00371c05666b9fa76de2e229032ec04302ed0b5192b6aee7"
    sha256 cellar: :any,                 arm64_monterey: "c0cbac6f2cd0c3063674306c424450f65c7a36478455e7fcea4aa2e44d6f1ece"
    sha256 cellar: :any,                 arm64_big_sur:  "17a69e4daafd969882c6ef315642bdee8da00b2268dfb5f10160860b19f9df93"
    sha256 cellar: :any,                 ventura:        "510b615d4892a2075614824946e3a9621b4c58ee62d69984cc175cba407fee75"
    sha256 cellar: :any,                 monterey:       "8b4a43990882fa596522f1599c3997775ceaf5eb1b7f6e99abb7a68744287f77"
    sha256 cellar: :any,                 big_sur:        "bb6041257e554a20254f85fe53860c67bada971a50dc9410f33679a83081c141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d8823e7cb59f3c87511de642a5902a0b825b129f2b7fe5adc08f7f9a80e8f5"
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
