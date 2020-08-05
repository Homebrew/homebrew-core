class Direvent < Formula
  desc "Monitors events in the file system directories"
  homepage "https://www.gnu.org.ua/software/direvent/direvent.html"
  url "https://ftp.gnu.org/gnu/direvent/direvent-5.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/direvent/direvent-5.2.tar.gz"
  sha256 "239822cdda9ecbbbc41a69181b34505b2d3badd4df5367e765a0ceb002883b55"

  bottle do
    cellar :any_skip_relocation
    sha256 "5aa186d6c50f9865450430bd7641c2be32380ab3eaa3f67e8fe4803cd2139b8d" => :catalina
    sha256 "0e9d14d7340a3031305913d1a506f17ebedfaae4b6da0c340d23f754de3fc4c7" => :mojave
    sha256 "b1893330b8cd3c41bfcfb1a5a919bf887febf17b9e5067d428d31169c8218295" => :high_sierra
    sha256 "6b04f666ccddc5f843e2dae19ee9af577390e9f1642b284237e5055885fb9864" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/direvent --version")
  end
end
