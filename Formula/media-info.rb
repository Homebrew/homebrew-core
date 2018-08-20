class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/18.05/MediaInfo_CLI_18.05_GNU_FromSource.tar.bz2"
  version "18.05"
  sha256 "aaa70120ce7100f37c41c545d1a26d946e614dc858e6bd5ea91fa2e10b00f696"

  bottle do
    cellar :any
    sha256 "82817f3df51d73634e7ced9e347747f1c8660bb0b53dd73ff83f7b24716c1826" => :mojave
    sha256 "99bc2eae9ac0f372663c2ad2de1970f0d3bda860061240d6dd20a8eb8332b475" => :high_sierra
    sha256 "77c90fb595990beed8f5436e2dec309f065c5dddeacea648e2b8d7b081ead289" => :sierra
    sha256 "726ed97a08cfa889a344b5177ac76512f1a07d85bfaa06ab49bdefa287f54e23" => :el_capitan
  end

  depends_on "pkg-config" => :build

  def install
    cd "ZenLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
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
