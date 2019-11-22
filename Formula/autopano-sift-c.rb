class AutopanoSiftC < Formula
  desc "Find control points in overlapping image pairs"
  homepage "https://wiki.panotools.org/Autopano-sift-C"
  url "https://downloads.sourceforge.net/project/hugin/autopano-sift-C/autopano-sift-C-2.5.1/autopano-sift-C-2.5.1.tar.gz"
  sha256 "9a9029353f240b105a9c0e31e4053b37b0f9ef4bd9166dcb26be3e819c431337"
  revision 1

  bottle do
    cellar :any
    sha256 "6c95b627cbba417827b7955d6292a9c74d3993ccbcd60be4999765b2be4ac17e" => :catalina
    sha256 "4ccc74538e6f6b01fd42c659991d0ba67e2544eb135f130d052dd1d2688070d8" => :mojave
    sha256 "1127a58fa18f17bdf4776de9fa8871df153d80447ac7b03388aceef71da87b8a" => :high_sierra
    sha256 "8b3c5657e1b4b29848bc583b8794eb1739018058c42a291bf3016fee02ab0532" => :sierra
    sha256 "9845348b5630218469ee555c666677303fa8d9cf45cd7aa51b26e1bef81cd76f" => :el_capitan
    sha256 "f38fa9a0dc3b30352155bafdad91f18b01ddc11db7c27c164d23def252ec7513" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "libpano"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "Version #{version}", pipe_output("#{bin}/autopano-sift-c")
  end
end
