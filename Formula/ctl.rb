class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  url "https://github.com/ampas/CTL/archive/ctl-1.5.2.tar.gz"
  sha256 "d7fac1439332c4d84abc3c285b365630acf20ea041033b154aa302befd25e0bd"
  license "AMPAS"
  revision 5

  bottle do
    sha256 "e44cbdbb013b350d22ff4cafeeb2a8e93dd164dc36bb6e181fb5cf086a8345c1" => :catalina
    sha256 "6c88c03a0826a11e7267bf056e15362d4824cea2291b16af6db172d21f3654ce" => :mojave
    sha256 "61b7606c62fb60aa86d887084e1cb0aa194ff5c64cb9726208ee364f870d7b43" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "ilmbase"
  depends_on "libtiff"
  depends_on "openexr"

  # from https://github.com/ampas/CTL/pull/73
  patch do
    url "https://github.com/ampas/CTL/commit/bda2165b97e512a39ee67cf36fe95e1d897e823b.diff?full_index=1"
    sha256 "119c2410403d16d1ecfe88bc687c16a0a5645f91824eec8de2d996d1248a06fd"
  end

  # from https://github.com/ampas/CTL/pull/74
  patch do
    url "https://github.com/ampas/CTL/commit/0646adf9dcf966db3c6ec9432901c08387c1a1eb.diff?full_index=1"
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
