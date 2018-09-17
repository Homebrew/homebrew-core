class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-1.13.tar.gz"
  sha256 "f4d9285c38292c2de05e444d0ba271cbfe1a705eee37c2b23ea7c448ab37255a"

  bottle do
    cellar :any_skip_relocation
    sha256 "623b7f91e30f6c673893ff06c66a430736e918eb370b7c303a099cc6d87fb8df" => :mojave
    sha256 "5db180d05ce0d3e8571340f69916c5b867a9ad8f600873887881e692d6f7d333" => :high_sierra
    sha256 "17c8904b40c21d0fa8e1f9f5b7d40817911b34c1fc3f92360b98f6d43470a736" => :sierra
    sha256 "8a7eb78e5d778b71d688f1f935b775a7f55fd9319d1cec2988b809c359223a65" => :el_capitan
  end

  head do
    url "https://g.blicky.net/ncdu.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
  end
end
