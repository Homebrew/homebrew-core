class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-1.15.tar.gz"
  sha256 "4a593dc5cceb2492a9669f5f5d69d0e517de457a11036788ea4591f33c5297fb"

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
