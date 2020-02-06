class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.1.tar.bz2"
  sha256 "238ed6547e4c96b775d93aa6e4252982a763f62ecd201f6312f041212edc1798"

  bottle do
    sha256 "0013bfd8ad47785121a86258607c5643f0cf21f961b6d3dbc43d9a2b8f984571" => :catalina
    sha256 "e07892e27e711cfaafd3a7ba2bc2a86bfe8fbc5438cc443e11a1033486a567fb" => :mojave
    sha256 "93017205557b9629a506023b466400c12b4333b6d99ce48b83d53ceb02b538b5" => :high_sierra
    sha256 "5566054299b2a05716a3234c7c3d0acee15b4077360c89ec815b6162bee89319" => :sierra
    sha256 "4bd576f3d75594928348d30b3b3436cdeebba844be8a8ba65251eb1731de437e" => :el_capitan
    sha256 "e6b941f5aa2508a9628487cf40a186188f1dbf986a9a5ab2a824c57a03d45055" => :yosemite
    sha256 "d2a095ce47bdea35fad3f6f7ffac500ccc4dc8dd149a9c1dbbae2bbf92809886" => :mavericks
  end

  depends_on "flac"
  depends_on "libvorbis"
  depends_on "mad"

  # Fix duplicate symbol errors, remove in next release
  # https://github.com/mywave82/opencubicplayer/issues/15
  patch do
    url "https://github.com/mywave82/opencubicplayer/commit/04368dc54e649050517fe3a058e919fb5fb5f150.diff?full_index=1"
    sha256 "baf237701358a45c79fd9e31fec5ecf3c8087597b30e9846023ef2e76006bb58"
  end
  patch do
    url "https://github.com/mywave82/opencubicplayer/commit/1907b8f85e3e5fa61a02ad0ca3ce9bd30bfc0ea6.diff?full_index=1"
    sha256 "fc82d4d7f630885097efa2223bba4c941456f2d70e625b6721ca2e825fad2d43"
  end

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --without-x11
      --without-sdl
      --without-sdl2
      --without-desktop_file_install
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ocp", "--help"
  end
end
