class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.1.tar.bz2"
  sha256 "238ed6547e4c96b775d93aa6e4252982a763f62ecd201f6312f041212edc1798"
  license "GPL-2.0"

  bottle do
    sha256 "d9c557bc2f3161818fcf4701e7cc123bd6d2f85ff9e80df5976392de9102a737" => :catalina
    sha256 "e23ff51d2b5b9adaa44f5d851da94c836f68886bacc2cd739b30166a2ec04312" => :mojave
    sha256 "6b40bde3ba007a8b18451502bcf49841d8a3f75ec06a7d6a8e748f508e7dc1f9" => :high_sierra
  end

  depends_on "flac"
  depends_on "libvorbis"
  depends_on "mad"

  # Fix duplicate symbol errors, remove in next release
  # https://github.com/mywave82/opencubicplayer/issues/15
  patch do
    url "https://github.com/mywave82/opencubicplayer/commit/04368dc54e649050517fe3a058e919fb5fb5f150.patch?full_index=1"
    sha256 "27ba15871499ffcc540a59fcb2435945ab842af74265d1032a1bf0831c5cbe2b"
  end
  patch do
    url "https://github.com/mywave82/opencubicplayer/commit/1907b8f85e3e5fa61a02ad0ca3ce9bd30bfc0ea6.patch?full_index=1"
    sha256 "3260bcfbd27e4aa64081674081e9f06963b705b3f89ba8aabaa8f54bb995986f"
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
