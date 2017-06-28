class Moodbar < Formula
  desc "Generates .mood files for music tracks"
  homepage "https://userbase.kde.org/Amarok/Manual/Various/Moodbar"
  url "http://pkgs.fedoraproject.org/repo/pkgs/moodbar/moodbar-0.1.2.tar.gz/28c8eb65e83b30f71b84be4fab949360/moodbar-0.1.2.tar.gz"
  sha256 "3d53627c3d979636e98bbe1e745ed79e98f1238148ba4f8379819f9083b3d9c4"

  bottle do
    cellar :any
    sha256 "b21580cc4ef0328d05ca813d6696e48d4614f8cdd767c578d5eef8c0959d9c76" => :sierra
    sha256 "8f29fc2f20c66f5a3dd2bb790c6e2a2b3cb7d08e3c1d36e7bac0f715aabbe28f" => :el_capitan
    sha256 "bfbf6b1218c42e7c159ad894c6bf1756f8022cf3b46ca8584da7c0da69552a5f" => :yosemite
  end

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
