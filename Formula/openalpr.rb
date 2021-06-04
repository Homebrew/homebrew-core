class Openalpr < Formula
  desc "Automatic License Plate Recognition library"
  homepage "https://www.openalpr.com"
  url "https://github.com/openalpr/openalpr/archive/v2.3.0.tar.gz"
  sha256 "1cfcaab6f06e9984186ee19633a949158c0e2aacf9264127e2f86bd97641d6b9"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 big_sur:  "32953a90e352cc25eea99daad7fac67c7ce11f042fe366af029b16cc3f372c07"
    sha256 catalina: "0a05746932c63e1d0dd1749a7213ed0a9cff7d7da2cdfe49e032aeb1b1da56ad"
    sha256 mojave:   "64dd8cef3f2fe311304e0fffae5ed50dd37123d6611aae751ba272be956bf334"
  end

  depends_on "cmake" => :build
  depends_on "leptonica"
  depends_on "libtiff"
  depends_on "log4cplus"
  depends_on "opencv@2"
  depends_on "tesseract"

  def install
    mkdir "src/build" do
      args = std_cmake_args
      args << "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"
      args << "-DCMAKE_CXX_FLAGS=-std=c++11"
      args << "-DCMAKE_INSTALL_SYSCONFDIR:PATH=#{etc}"

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/alpr #{test_fixtures("test.jpg")}")
    assert_equal "No license plates found.", output.chomp
  end
end
