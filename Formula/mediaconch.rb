class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/16.07/MediaConch_CLI_16.07_GNU_FromSource.tar.bz2"
  version "16.07"
  sha256 "8f321af4edc5f241f7e55d7e234db64f4c2c5a263a685d509e682bc72850b447"

  bottle do
    cellar :any
    sha256 "6f7eeac5390cde40959e47bbd2f25238580bc47e3872f97adba3b70f0f346196" => :el_capitan
    sha256 "9fe3c7793e334eda819eb19fe0f253719371a424256a39f259e9ed7937c33c1e" => :yosemite
    sha256 "f6d6c44acbe8260fa718dca8abfaea7327a3d97a650769c88ee0a27a05267ac9" => :mavericks
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
