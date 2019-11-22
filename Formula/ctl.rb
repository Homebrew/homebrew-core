class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  url "https://github.com/ampas/CTL/archive/ctl-1.5.2.tar.gz"
  sha256 "d7fac1439332c4d84abc3c285b365630acf20ea041033b154aa302befd25e0bd"
  revision 3

  bottle do
    sha256 "0ad490aa788bd360a656878b50d31d3a943932072ab51c8b87a01ccfae9f8548" => :catalina
    sha256 "ab6441016e0027ca393e6c9a92224c5a684a5476cebd9fdb5c48f42dda81e5b2" => :mojave
    sha256 "fe9ebf7a5d7f115a0ba08ad2d72b21a65315ad213cc8d7cbda02ffba96ef8fde" => :high_sierra
    sha256 "ab156768e3ae9f46aac1dc14ee0aed58173657ab0cadbb6e85f43bf68a6fd4c6" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "ilmbase"
  depends_on "libtiff"
  depends_on "openexr"

  patch do
    url "https://github.com/ampas/CTL/pull/73.diff?full_index=1"
    sha256 "119c2410403d16d1ecfe88bc687c16a0a5645f91824eec8de2d996d1248a06fd"
  end

  def install
    ENV.delete "CTL_MODULE_PATH"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /transforms an image/, shell_output("#{bin}/ctlrender -help", 1)
  end
end
