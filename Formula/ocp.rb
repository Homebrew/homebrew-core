class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://sourceforge.net/projects/opencubicplayer/"
  url "https://downloads.sourceforge.net/project/opencubicplayer/ocp-0.1.21/ocp-0.1.21.tar.bz2"
  sha256 "d88eeaed42902813869911e888971ab5acd86a56d03df0821b376f2ce11230bf"

  bottle do
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

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --without-x11
      --without-sdl
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
