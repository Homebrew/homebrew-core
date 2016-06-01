class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.86/MediaInfo_CLI_0.7.86_GNU_FromSource.tar.bz2"
  version "0.7.86"
  sha256 "d874dfc62f834b7bb5ac0d2de8e314340b332dccc92f3806dd3b784200ce09d1"

  bottle do
    cellar :any
    sha256 "fa6c132217c84a40c133c63a3171a3bf3616a52a69ad941525d40963a23e0da9" => :el_capitan
    sha256 "c6e0a621dc8a8f7801b42c7fed0220c09ceeb09896ef22e3715f9142eb7492b4" => :yosemite
    sha256 "fadc08fffcfc559fe463283a934806914c895a2b814f304ae541dd855d6970d2" => :mavericks
  end

  depends_on "pkg-config" => :build
  # fails to build against Leopard's older libcurl
  depends_on "curl" if MacOS.version < :snow_leopard

  def install
    cd "ZenLib/Project/GNU/Library" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--with-libcurl",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediainfo", test_fixtures("test.mp3"))
  end
end
