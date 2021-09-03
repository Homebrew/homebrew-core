class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.9.9.tar.gz"
  sha256 "9f053338752ec96a6b619718037767682c5fd58e2471c08f3740fdb070605bc0"
  license "CECILL-2.1"
  head "https://github.com/dtschump/gmic.git"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b4ca938c13a0d48444a68b260556af081c92c7155f837ee967ab325687f97cd1"
    sha256 cellar: :any,                 big_sur:       "aaf9c8289fca869eb689a3c8df531c88d06a7f20e66834476040b28bda1d8f27"
    sha256 cellar: :any,                 catalina:      "2393fee531477a0737818b367e8a7fd1bf5b2d1834c9f71d0424d9fdfe35289d"
    sha256 cellar: :any,                 mojave:        "06c829f95058ad32cd4c851fef13238008215252775cd35218428d440b8d3eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a575f45f76d9652e38f78982d5a5edb053191f99a4125805971f7cc2441332c"
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    system "cmake", *std_cmake_args,
                    "-DENABLE_FFMPEG=OFF",
                    "-DENABLE_OPENCV=OFF",
                    "-DENABLE_OPENEXR=OFF",
                    "-DENABLE_X=OFF"
    system "make", "install"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
    system bin/"gmic", "-input", test_fixtures("test.jpg"), "rodilius", "10,4,400,16",
           "smooth", "60,0,1,1,4", "normalize_local", "10,16", "-output", testpath/"test_rodilius.jpg"
    assert_predicate testpath/"test_rodilius.jpg", :exist?
  end
end
