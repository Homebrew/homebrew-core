class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/18.03.2/MediaConch_CLI_18.03.2_GNU_FromSource.tar.bz2"
  version "18.03.2"
  sha256 "8f8f31f1c3eb55449799ebb2031ef373934a0a9826ce6c2b2bdd32dacbf5ec4c"
  revision 1

  bottle do
    cellar :any
    sha256 "41a49bbafbffc220f140d8e466f1507757cbe552f8de4ca306217affbf1e6dd5" => :catalina
    sha256 "9d59b85fecc5d5caba622fe57358caab23c8ea904954a137b99e66dd4f7fedec" => :mojave
    sha256 "d59cfb9ac07ffb7eacc4c7970c38676a3909f0966481b99c745735bf87db7b8e" => :high_sierra
    sha256 "fdb3934174a68121357c21d4f0800e8bbbaa6a296f3386ab52e5298fde96a6b6" => :sierra
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
