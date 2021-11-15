class Boxes < Formula
  desc "Draw boxes around text"
  homepage "https://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/v2.1.1.tar.gz"
  sha256 "95ae6b46e057a79c6414b8c0b5b561c3e9d886ab8123a4085d256edccce625f9"
  license "GPL-2.0-only"
  head "https://github.com/ascii-boxes/boxes.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "e8b8eca263957a235a37c69e99c30753c5f784d3b2ca782a51da94a4c339cdf6"
    sha256 arm64_big_sur:  "8a84a206ca3a46d2364dd51f3e025762545645ff161e593a60149fc55e7a1f97"
    sha256 monterey:       "aeb6f5c6587634067ea8ba32f7a92cd1d3e8b7503ddd8c8afbaefd9f279e5e87"
    sha256 big_sur:        "eba500de77351541b21e68725366e61c7f6452cf097d72d7098ebb752d9d6f8f"
    sha256 catalina:       "26564383c477c7e9e77ae94ab8d4fdb26cbaf2d530b768d01f93b72c1567b0c8"
    sha256 mojave:         "e42c888a34141a1cff3b52404f0e35d1de820f64b2d7d7bf973684a8e234b1bd"
  end

  depends_on "bison" => :build
  depends_on "libunistring"
  depends_on "pcre2"

  def install
    # distro uses /usr/share/boxes change to prefix
    system "make", "GLOBALCONF=#{share}/boxes-config",
                   "CC=#{ENV.cc}",
                   "YACC=#{Formula["bison"].opt_bin/"bison"}"

    bin.install "out/boxes"
    man1.install "doc/boxes.1"
    share.install "boxes-config"
  end

  test do
    assert_match "test brew", pipe_output("#{bin}/boxes", "test brew")
  end
end
