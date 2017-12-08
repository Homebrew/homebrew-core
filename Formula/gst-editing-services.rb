class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.12.4.tar.xz"
  sha256 "bd7eaa2c9572db9e7e535064024b6f69250de864fe8a5d5be86fa8c7edacca0c"

  bottle do
    sha256 "fede2d7884a0dccc68b3ce37e15cb94d68f25b82944abec97bc7d5ef8b85053a" => :high_sierra
    sha256 "a7e1edba4cfee20e354ad3a4ea655e1a4cd899a17ad0d11344bbe43ff1e64a7f" => :sierra
    sha256 "ca9084be6a553b865212b7cdb916a971cd9e51a55b6705f53943687e1d760c58" => :el_capitan
  end

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
