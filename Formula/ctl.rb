class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  url "https://github.com/ampas/CTL/archive/ctl-1.5.2.tar.gz"
  sha256 "d7fac1439332c4d84abc3c285b365630acf20ea041033b154aa302befd25e0bd"
  revision 4

  bottle do
    sha256 "e76d1577ae18eff19a8a4b82941ab42d1be88e0cede2e6f53daaf611363a1eee" => :catalina
    sha256 "42fae5bdcc9ebd6fdcf65048748659a0f5d27169396cf4dc2aef6668263ff8a4" => :mojave
    sha256 "1a63d9afedf0845adb9daf5b7700c5715217e477b99453dc02c50be0eb9e8565" => :high_sierra
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

  patch do
    url "https://github.com/ampas/CTL/pull/74.diff?full_index=1"
    sha256 "0c261caf34f14a097811ceb82fc1d9aa29bc6c4861921361e6eb1b4fe5f8ebae"
  end

  def install
    ENV.cxx11
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
