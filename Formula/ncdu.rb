class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-1.14.2.tar.gz"
  sha256 "947a7f5c1d0cd4e338e72b4f5bc5e2873651442cec3cb012e04ad2c37152c6b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d36e74ca5914631c1ef3748c4402bddeb818e60bdea9bdf7ffab7db90f217b5" => :catalina
    sha256 "34f8996befd630dd0e753bae26a4cea819e0315576e590976677195daa09df5d" => :mojave
    sha256 "2a439d984233bfc5bc7f0202cfb4ebac27236e1d86c03c72676b761560299e44" => :high_sierra
  end

  head do
    url "https://g.blicky.net/ncdu.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "ncurses"

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
