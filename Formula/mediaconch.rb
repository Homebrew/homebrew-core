class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/22.03/MediaConch_CLI_22.03_GNU_FromSource.tar.bz2"
  sha256 "0c35434b55c7f507b20ef13e0a33fdbc4868cca353b145abb5d2cd13c7f11f23"

  livecheck do
    url "https://mediaarea.net/MediaConch/Download/Source"
    regex(/href=.*?mediaconch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "49c74edbd5813f2a2c8455bbec92bc3b6ba8e47b286275bb50f61acc550293f2"
    sha256 cellar: :any,                 arm64_big_sur:  "2bc516280f29cda43dcda638a0a5dd586a34fc52beb724bd97f382825d347d7a"
    sha256 cellar: :any,                 monterey:       "09fc40239da4fef379b16f29327ba1e9fa72bd08bf361b81e4fdda5a9aaac9a1"
    sha256 cellar: :any,                 big_sur:        "1ab9e887a8787b4b3655df4f9b01214da00ef466da186db7dca1ae646bb09b3d"
    sha256 cellar: :any,                 catalina:       "41a49bbafbffc220f140d8e466f1507757cbe552f8de4ca306217affbf1e6dd5"
    sha256 cellar: :any,                 mojave:         "9d59b85fecc5d5caba622fe57358caab23c8ea904954a137b99e66dd4f7fedec"
    sha256 cellar: :any,                 high_sierra:    "d59cfb9ac07ffb7eacc4c7970c38676a3909f0966481b99c745735bf87db7b8e"
    sha256 cellar: :any,                 sierra:         "fdb3934174a68121357c21d4f0800e8bbbaa6a296f3386ab52e5298fde96a6b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87ccb6aac84590c501a35ea7ce511f21d1f902a7d37dbdcef722a7c6149dee0f"
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "sqlite"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

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
