class Libcdio < Formula
  desc "Compact Disc Input and Control Library"
  homepage "https://www.gnu.org/software/libcdio/"
  url "https://ftp.gnu.org/gnu/libcdio/libcdio-2.1.0.tar.bz2"
  mirror "https://ftpmirror.gnu.org/libcdio/libcdio-2.1.0.tar.bz2"
  sha256 "8550e9589dbd594bfac93b81ecf129b1dc9d0d51e90f9696f1b2f9b2af32712b"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "118cf68c27ed81b7b99dde4419ba1fb8c6734568face2b741c1aeefa1a567cf1"
    sha256 cellar: :any,                 arm64_monterey: "1a494adcac50f09c217499a52a3bc585164e31bc655208f9d1239599b6687c61"
    sha256 cellar: :any,                 arm64_big_sur:  "48111a6c9c6f82aeafae559a73aa8acb1c33eb12f71e059a5d6a4bcdab846206"
    sha256 cellar: :any,                 ventura:        "06bfca059c6f5e949f8e45ac6c218b13df8ec4e3efa9720f4a16c3f87203820f"
    sha256 cellar: :any,                 monterey:       "bedfea3e35f4b1a7fa77ee2f8da00fb603e012b9be281a449b924e9487a5fd18"
    sha256 cellar: :any,                 big_sur:        "d8bddd24c6d4686f77bd507fdb3380ce6acd3b3f799188e8961d1feeb269c422"
    sha256 cellar: :any,                 catalina:       "3ec17ce98e129db74cb883941e429286b9ab762c740dcb6ee8c7ff077d6e3304"
    sha256 cellar: :any,                 mojave:         "55014a60373e44384aa7f797c613ccd5289c55d759c3521b7e5d6819ff54b2ac"
    sha256 cellar: :any,                 high_sierra:    "32604fb219cc4e59e5eb1e0937b320edfacf31d97f04b9a5fbfcd4354a6a56d0"
    sha256 cellar: :any,                 sierra:         "61095f7c4888b1c0e022ec9eb314fe389feae1eb030d65e7d91512515528e439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c87bf684fc0785e0b70ce4ff982625326e65f0e79fdbe528693a81f979e12253"
  end

  depends_on "pkg-config" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cd-info -v", 1)
  end
end
