class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/16.09/MediaConch_CLI_16.09_GNU_FromSource.tar.bz2"
  version "16.09"
  sha256 "e85d99ffbdbd45f77b953692fb39fabc89745a4811ecc5729223b264ebf77b54"

  bottle do
    cellar :any
    sha256 "7bb682261c8845a9599ccd4c9197ba13546fb2d4a1f9f84d00d3e618320b5589" => :sierra
    sha256 "a5dedf81cac51529ccec54e5a08a8d8147337dc52c4f14de7c0eaabdeec05142" => :el_capitan
    sha256 "de5cbef79d398334e7b8c6ba96191f975af518027b41a522b806cb827e872184" => :yosemite
    sha256 "e9d8638544f5cf2bbbbc0572a5e62e186d7f2eb055c1dd3d7a8c2f17e477bd01" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "sqlite"
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
              "--prefix=#{prefix}",
              # mediaconch installs libs/headers at the same paths as mediainfo
              "--libdir=#{lib}/mediaconch",
              "--includedir=#{include}/mediaconch"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaConch/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediaconch", test_fixtures("test.mp3"))
  end
end
