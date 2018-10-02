class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.7.tar.xz"
  sha256 "585b8e88ed04bdb426403cf7d9b0c0bb9c7630755b0096c2b018a024b29bec0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a0227fbdf908f35baa2f00bd00233ca9d075ff54b38eba5efacddc1af4905f5" => :mojave
    sha256 "8d6c4fbdd50559fac6cfc1ef43009b52a1f6c28cc9c2a823e1f29545d8a712a4" => :high_sierra
    sha256 "8d6c4fbdd50559fac6cfc1ef43009b52a1f6c28cc9c2a823e1f29545d8a712a4" => :sierra
    sha256 "8d6c4fbdd50559fac6cfc1ef43009b52a1f6c28cc9c2a823e1f29545d8a712a4" => :el_capitan
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
