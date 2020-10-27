class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.9.2.tar.gz"
  sha256 "385db1ef3ef5805bc7bcb65255e188e349fc5e0ae35687b1b914291212bc4c91"
  license "CECILL-2.1"
  head "https://github.com/dtschump/gmic.git"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "30c6b5b1fec7e0459e641534a997edef796e77bff237613edecd7936d940a451" => :catalina
    sha256 "62b1b6038e8959dfc710aa99aab1db4aee3bba229dc1026bab759bc87d48604b" => :mojave
    sha256 "9f9c1fe989919a01952f89c45d1a2b0e128b8007afc1dd14e5264e0661f3f63a" => :high_sierra
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
