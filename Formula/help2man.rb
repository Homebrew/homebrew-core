class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.16.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.16.tar.xz"
  sha256 "3ef8580c5b86e32ca092ce8de43df204f5e6f714b0cd32bc6237e6cd0f34a8f4"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "457a2b1ce094f9997ac5555a843d025eb9bc2267a54be0a1f2292b67a038de72" => :catalina
    sha256 "e06ed538e4c68bec3c3e759ef12961c42288238dd82cdb948e40d6c98733f07d" => :mojave
    sha256 "457a2b1ce094f9997ac5555a843d025eb9bc2267a54be0a1f2292b67a038de72" => :high_sierra
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
