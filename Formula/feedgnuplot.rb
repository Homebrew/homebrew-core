class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.48.tar.gz"
  sha256 "6befa4d75abe5de263d2e49091707af81bd987fe1587b9acb1ae945b8d494a7c"

  bottle do
    cellar :any_skip_relocation
    sha256 "487443b0558735b65559539c3fb6bbc551777169feaa87345ee19ccbdbd09fee" => :high_sierra
    sha256 "d46ced4f11a11aa8a49e4e4c2e6845b342d2e07c45e4a0b3d195ddd34af55a43" => :sierra
    sha256 "65ca43a4515aa24d74e71b1491a1a701ece42d4280f3f7746d7170b1bcb25e05" => :el_capitan
  end

  depends_on "gnuplot"

  def install
    system "perl", "Makefile.PL", "prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/feedgnuplot --terminal 'dumb 80,20' --exit", "seq 5", 0)
  end
end
