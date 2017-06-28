class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.4.tar.xz"
  sha256 "d4ecf697d13f14dd1a78c5995f06459bff706fd1ce593d1c02d81667c0207753"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b3480705ebb76f26f4d92a19896f298d48b7e156dd756af387ebd78b7a84eb9" => :sierra
    sha256 "1ce372ea4da79821e251a867c380232a036569d5e05ab8734ca52bd25b9ff3bb" => :el_capitan
    sha256 "b52243aae3f9552873d6a0befa2158c116993560719b7aada59dbafb2cdf281d" => :yosemite
    sha256 "d63079ec5272bb4d5be4c244ffa36af7ddbcb0fd738e2acfb657b8268b932c05" => :mavericks
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "help2man #{version}", shell_output("#{bin}/help2man #{bin}/help2man")
  end
end
