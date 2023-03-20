class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "http://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.1.3_src.tar.gz"
  sha256 "264f135ad89f443b8b103169ca28e95ba488f2ce627c6dc3791e0230587be0d9"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7688445abd1ce084ee77872cbae26fe5408530114512e672ba066c416f099c64"
    sha256 cellar: :any,                 arm64_monterey: "50241349fd575ffdfe56be4888a7f7be5ca39e2b389496f89c28bae5417dff09"
    sha256 cellar: :any,                 arm64_big_sur:  "b9b4cce0da5b171c57cb1b71d7fbe767e47288c12ae191a47b8ec06452288974"
    sha256 cellar: :any,                 ventura:        "5cbd8bcf42c097b974f0eef8c16760cf47bb13c32a9f31fba0e8633e249d3536"
    sha256 cellar: :any,                 monterey:       "758ae3a0f2b407b926d33d2aea57c25770e1313991206911df766a98f5cce49f"
    sha256 cellar: :any,                 big_sur:        "48407e792ddcfec7b9bee676c8672244afcad0371b8534bbdd4366be5bb321bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e32aa2009d5d2052978138a9c82985bf47ed7f754aafc6b4d7a834643f46bd2"
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
