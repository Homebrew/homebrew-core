class Mapmap < Formula
  desc "Video mapping software"
  homepage "https://mapmapteam.github.io/"
  url "https://github.com/mapmapteam/mapmap/archive/0.6.2.tar.gz"
  sha256 "2f1b8236d448b6839395fd78b1d407c034749a549666270f2a17e6b5f2d25c78"
  head "https://github.com/mapmapteam/mapmap.git"

  depends_on "pkg-config" => :build
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "liblo"
  depends_on "qt"
  depends_on "gst-libav" => :recommended
  depends_on "gst-plugins-good" => :recommended

  def install
    inreplace "src/src.pri" do |s|
      s.gsub! "INCLUDEPATH += /Library/Frameworks/GStreamer.framework/Versions/1.0/Headers",
              "QMAKE_CXXFLAGS += #{`pkg-config --cflags gstreamer-1.0 gstreamer-app-1.0 gstreamer-pbutils-1.0`.chomp!}"
      s.gsub! "LIBS += -F /Library/Frameworks/ -framework GStreamer",
              "LIBS += #{`pkg-config --libs gstreamer-1.0 gstreamer-app-1.0 gstreamer-pbutils-1.0`.chomp!}"
      s.gsub! "# CONFIG-=app_bundle",
              "CONFIG-=app_bundle"
    end

    system "qmake", "-config", "release"
    system "make"
    bin.install "MapMap"
  end

  test do
    system "#{bin}/MapMap", "--version"
  end
end
