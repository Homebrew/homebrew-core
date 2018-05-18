class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.14.1.tar.xz"
  sha256 "7e7c0962f39388cdf81b5e0d9f768eb15e30f58b346fd79f1ea778979eae113e"

  bottle do
    sha256 "4e2e03a93ce8016174b938050675bde833a48ed73008d8464c8b50de9bd790ad" => :high_sierra
    sha256 "121dfe755996c0aeb88a4c239be99ea1c831e8ab655886418721b4f47588401c" => :sierra
    sha256 "aab3f5d4909908af856a96eafd11087ae775d06b416e6deaf4777d6f738a72d5" => :el_capitan
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
