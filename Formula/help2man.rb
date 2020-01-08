class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.12.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.12.tar.xz"
  sha256 "7d0ba64cf9d16ec97cc11aafb659b55aa7bdec99072ff2aec5fcecf0fbeab160"

  bottle do
    cellar :any_skip_relocation
    sha256 "d86f9f72873142b817df048f666d62925a028c982d58016448f2a0dc4646b19a" => :catalina
    sha256 "d86f9f72873142b817df048f666d62925a028c982d58016448f2a0dc4646b19a" => :mojave
    sha256 "d86f9f72873142b817df048f666d62925a028c982d58016448f2a0dc4646b19a" => :high_sierra
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
