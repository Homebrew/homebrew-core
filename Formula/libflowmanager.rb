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
    sha256 cellar: :any, arm64_big_sur: "0ee5ac027b4b6147a242372d436af6c842a715d8eda53a12520412bbbe68a833"
    sha256 cellar: :any, big_sur:       "a72f919e29358d8c3698ba0b4677b4c46effef119591dc38b6e99c244731329e"
    sha256 cellar: :any, catalina:      "3062037389000f22d292506d3129dd99575bbc9cb73d6a1e65483c2935e35329"
    sha256 cellar: :any, mojave:        "5358da08e9444be464325d1b2745b808a26916b79a3eec2810a52068fc2ad7fc"
  end

  depends_on "libtrace"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
