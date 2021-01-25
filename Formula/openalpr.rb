class Openalpr < Formula
  desc "Automatic License Plate Recognition library"
  homepage "https://www.openalpr.com"
  url "https://github.com/openalpr/openalpr/archive/v2.3.0.tar.gz"
  sha256 "1cfcaab6f06e9984186ee19633a949158c0e2aacf9264127e2f86bd97641d6b9"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 "8cf1530f286a3223c92ff60f13f377f6a1016b1bca53dd85b91b7f2c273aa6e7" => :big_sur
    sha256 "82858b6fa8b3882e8e7a890fd256420b2aa0dff86ad79071b26f256cb7823b26" => :catalina
    sha256 "4cbe016b79dbe619488e08f3be8d89b573fb4307437efc837fe8be16172f4625" => :mojave
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
