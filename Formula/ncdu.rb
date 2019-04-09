class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-1.14.tar.gz"
  sha256 "c694783aab21e27e64baad314b7c1ff34541bfa219fe9645ef6780f1c5558c44"

  bottle do
    cellar :any_skip_relocation
    sha256 "692b24d1716e5506519d5d410f3ea58421622a6eaeeed599500164b07b700c3c" => :mojave
    sha256 "72bb45a38627439df5107dea24d5c88731c3c5de9018282b08586ce2712af381" => :high_sierra
    sha256 "54c677b9f5985244e59ce78f3d55883f8149423d90565a5ba7965173416bce27" => :sierra
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
