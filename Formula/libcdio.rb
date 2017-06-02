class Libcdio < Formula
  desc "Compact Disc Input and Control Library"
  homepage "https://www.gnu.org/software/libcdio/"
  url "https://ftp.gnu.org/gnu/libcdio/libcdio-0.94.tar.gz"
  mirror "https://ftpmirror.gnu.org/libcdio/libcdio-0.94.tar.gz"
  sha256 "96e2c903f866ae96f9f5b9048fa32db0921464a2286f5b586c0f02699710025a"

  bottle do
    cellar :any
    sha256 "a33a83ce904f907197bea29caab598b3fb505c0057a720e4b0ac1d7f8b19e15c" => :sierra
    sha256 "b875027374fb8585468bc1c75161ff893598ec0f5490b6d542fd5a80b7e77052" => :el_capitan
    sha256 "45f6e37c831b5cbadd68721efc070196b0946b24f4ac05d532b4fcd65d30289b" => :yosemite
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/cd-info -v", 1)
  end
end
