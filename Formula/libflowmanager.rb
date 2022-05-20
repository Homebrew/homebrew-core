class Libflowmanager < Formula
  desc "Flow-based measurement tasks with packet-based inputs"
  homepage "https://research.wand.net.nz/software/libflowmanager.php"
  url "https://research.wand.net.nz/software/libflowmanager/libflowmanager-3.0.0.tar.gz"
  sha256 "0866adfcdc223426ba17d6133a657d94928b4f8e12392533a27387b982178373"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?libflowmanager[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d73a9c5834f5cceceefda2547bebb79ab267df8244af23525a0b9347127c6ce1"
    sha256 cellar: :any,                 arm64_big_sur:  "0ee5ac027b4b6147a242372d436af6c842a715d8eda53a12520412bbbe68a833"
    sha256 cellar: :any,                 monterey:       "3ba52841763b302ad36c51d5e1f48bd54491ad1c735ab08ab1f1fc010b6b7807"
    sha256 cellar: :any,                 big_sur:        "a72f919e29358d8c3698ba0b4677b4c46effef119591dc38b6e99c244731329e"
    sha256 cellar: :any,                 catalina:       "3062037389000f22d292506d3129dd99575bbc9cb73d6a1e65483c2935e35329"
    sha256 cellar: :any,                 mojave:         "5358da08e9444be464325d1b2745b808a26916b79a3eec2810a52068fc2ad7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ee9bff7bfd92e6794746f74634273457b92fbb7c94934cea4c07d3f0d9c08e7"
  end

  depends_on "libtrace"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
