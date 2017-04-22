class Moodbar < Formula
  desc "Generates .mood files for music tracks"
  homepage "https://userbase.kde.org/Amarok/Manual/Various/Moodbar"
  url "http://pkgs.fedoraproject.org/repo/pkgs/moodbar/moodbar-0.1.2.tar.gz/28c8eb65e83b30f71b84be4fab949360/moodbar-0.1.2.tar.gz"
  sha256 "3d53627c3d979636e98bbe1e745ed79e98f1238148ba4f8379819f9083b3d9c4"

  depends_on "gstreamer@0.10"
  depends_on "fftw"
  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gst-plugins-base@0.10" => :recommended
  depends_on "gst-plugins-good@0.10" => :recommended
  depends_on "gst-plugins-bad@0.10" => :recommended
  depends_on "gst-plugins-ugly@0.10" => :recommended

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-plugindir=#{lib}/gstreamer-0.10",
                          "--with-gstreamer=#{prefix}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"moodbar", "-o", "test.mood", test_fixtures("test.wav")
    assert File.exist?("test.mood")
  end
end
