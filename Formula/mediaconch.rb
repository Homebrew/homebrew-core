class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/18.03.1/MediaConch_CLI_18.03.1_GNU_FromSource.tar.bz2"
  version "18.03.1"
  sha256 "cd46ccdbaa763743f2869c1df5318b839425157f12e7dfaa6bbc02cd0990238a"

  bottle do
    cellar :any
    sha256 "0868c9c34b8572c85fb075bdd3e8fddc134dacb0ced4a5269aa0e543a6a5123a" => :high_sierra
    sha256 "26de1fa891c400c8e0eaf0b61adc01351f90ea8925365aa409aafdb1ed8ce718" => :sierra
    sha256 "4d75b696e3ac13c4e87febb5c84581241ec4f3c424b302e487032110ff18044a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "sqlite"

  def install
    cd "ZenLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--enable-shared",
              "--enable-static",
              "--prefix=#{prefix}",
              # mediaconch installs libs/headers at the same paths as mediainfo
              "--libdir=#{lib}/mediaconch",
              "--includedir=#{include}/mediaconch"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--enable-static",
              "--enable-shared",
              "--with-libcurl",
              "--prefix=#{prefix}",
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
