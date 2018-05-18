class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.14.1.tar.xz"
  sha256 "7e7c0962f39388cdf81b5e0d9f768eb15e30f58b346fd79f1ea778979eae113e"

  bottle do
    cellar :any
    sha256 "dddd6a905cf531080a04e7f8af75c8dfa9406387aa29a086dee47765460be518" => :high_sierra
    sha256 "52be6d8262363557d5148a2b780521bede1da5a3c08e7a3b1d8c88534af65486" => :sierra
    sha256 "071cfb5213cf5b6ed166e79b59c9dfe12ec1c9270e152c79f9cd6755e196b29e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gstreamer"
  depends_on "gst-plugins-base"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-gtk-doc",
                          "--disable-docbook"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ges-launch-1.0", "--ges-version"
  end
end
