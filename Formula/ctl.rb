class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  url "https://github.com/ampas/CTL/archive/ctl-1.5.2.tar.gz"
  sha256 "d7fac1439332c4d84abc3c285b365630acf20ea041033b154aa302befd25e0bd"
  revision 2

  bottle do
    sha256 "16f2a8692af07f7710d558e4de69a88705df2dd153e00dc36fdfb0d3a2accc0e" => :mojave
    sha256 "edb2ab8944366710827ab289c0c0c6846642524fd0928dfab8cb8be033cd465d" => :high_sierra
    sha256 "6668abc43f329b3220882182fa9f45c04e273f9f3d91a78a9c352df55d85171c" => :sierra
    sha256 "744fa25276716928e3b7e43e1f176151fdcf1b60fab95b2f3308467d77bf75a6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "ilmbase"
  depends_on "libtiff"
  depends_on "openexr"

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
