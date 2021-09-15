class AutopanoSiftC < Formula
  desc "Find control points in overlapping image pairs"
  homepage "https://wiki.panotools.org/Autopano-sift-C"
  url "https://downloads.sourceforge.net/project/hugin/autopano-sift-C/autopano-sift-C-2.5.1/autopano-sift-C-2.5.1.tar.gz"
  sha256 "9a9029353f240b105a9c0e31e4053b37b0f9ef4bd9166dcb26be3e819c431337"
  revision 1

  bottle do
    sha256 cellar: :any, catalina:    "6c95b627cbba417827b7955d6292a9c74d3993ccbcd60be4999765b2be4ac17e"
    sha256 cellar: :any, mojave:      "4ccc74538e6f6b01fd42c659991d0ba67e2544eb135f130d052dd1d2688070d8"
    sha256 cellar: :any, high_sierra: "1127a58fa18f17bdf4776de9fa8871df153d80447ac7b03388aceef71da87b8a"
    sha256 cellar: :any, sierra:      "8b3c5657e1b4b29848bc583b8794eb1739018058c42a291bf3016fee02ab0532"
    sha256 cellar: :any, el_capitan:  "9845348b5630218469ee555c666677303fa8d9cf45cd7aa51b26e1bef81cd76f"
    sha256 cellar: :any, yosemite:    "f38fa9a0dc3b30352155bafdad91f18b01ddc11db7c27c164d23def252ec7513"
  end

  # Upstream dropped support due to unclear licensing terms.  See:
  #   https://groups.google.com/g/hugin-ptx/c/85yJ6SSd7Eo/m/SkxWF3hGBQAJ
  # Last update was in 2009
  disable! date: "2021-03-28", because: :no_license

  depends_on "cmake" => :build
  depends_on "libpano"

  def install
    # libpano includes Carbon.h which on Big Sur indirectly includes CarbonCore/Components.h
    # This defines a typedef named "Component" which causes a conflict with a typedef used
    # internally by this package
    inreplace %w[APSCpp/APSCpp_main.c MatchKeys.c AutoPanoSift.h AutoPano.c APSCmain.c],
              /\bComponent\b/, "Pano_Component"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "Version #{version}", pipe_output("#{bin}/autopano-sift-c")
  end
end
