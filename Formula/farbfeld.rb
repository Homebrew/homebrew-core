class Farbfeld < Formula
  desc "Tools for working with the farbfeld image format"
  homepage "https://tools.suckless.org/farbfeld/"
  url "https://dl.suckless.org/farbfeld/farbfeld-4.tar.gz"
  sha256 "c7df5921edd121ca5d5b1cf6fb01e430aff9b31242262e4f690d3af72ccbe72a"
  license "ISC"
  head "https://git.suckless.org/farbfeld"

  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    # this is just a 1x1 image with 0xfefe red, 0x0000 green&blue & 0xffff alpha
    testimg = "ZmFyYmZlbGQAAAABAAAAAf7+AAAAAP//"
    system "echo '#{testimg}' | base64 --decode > #{testpath}/a"
    system "#{bin}/ff2png < #{testpath}/a | #{bin}/png2ff > #{testpath}/b"
    system "#{bin}/ff2jpg < #{testpath}/b | #{bin}/jpg2ff > #{testpath}/c"
    assert_equal testimg, shell_output("base64 < #{testpath}/c").strip
  end
end
