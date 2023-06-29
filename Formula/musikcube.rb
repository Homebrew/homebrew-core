class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  url "https://github.com/clangen/musikcube/archive/3.0.1.tar.gz"
  sha256 "94fe7e2dba60137bbfee25c037850ac064744cd8c050cc76360580b2b6790632"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/clangen/musikcube.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "536bdc6b3e27c7d83f2634de933e0fba13a21d0017f078a975ccdf93ac06c840"
    sha256 arm64_monterey: "e49881571854ac5a280e32c2c0b3ae5344df48f334b8359ac879a983d7ec68e3"
    sha256 arm64_big_sur:  "3974a891f2570db4d354d6157adf75d1be43ddc7220f5225b2d4c2afd869efe0"
    sha256 ventura:        "bffffdf3f530d78ff18bc4889d9c0cfa4c67819cb85f46dea0bad041df066b0a"
    sha256 monterey:       "541d265dd774e6a2b29bd9421c98b7e31fe93fa95d369d50541d5dcb090e2944"
    sha256 big_sur:        "f890ef84c1d502e49f18e4b0af2d021091c0d162477798e619a69f20aa032787"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "game-music-emu"
  depends_on "gnutls"
  depends_on "lame"
  depends_on "libev"
  depends_on "libmicrohttpd"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libvorbis"
  depends_on :macos
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "taglib"
  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"musikcubed", "--start"
    system "sleep", "5"
    assert_path_exists "/tmp/musikcubed.lock"
    system "sleep", "5"
    system bin/"musikcubed", "--stop"
  end
end
