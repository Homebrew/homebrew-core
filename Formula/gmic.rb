class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_2.1.5.tar.gz"
  sha256 "2f3de90a09bba6d24c89258be016fd6992886bda13dbbcaf03de58c765774845"
  revision 2
  head "https://github.com/dtschump/gmic.git"

  bottle do
    cellar :any
    sha256 "09322413b52ce5865967d68dc2f5a6153a147b83a69f20a3f5b5ac9498676b6b" => :mojave
    sha256 "13ccaf356dc8be85d6d60078c5c10ad3ae6fd515169c396b6cb1c28b2a348c15" => :high_sierra
    sha256 "7ed192f9ad04036d236cbe9b854ea54325bb366ec392d4cb977e227167ce1ebf" => :sierra
    sha256 "db45390cb89c9a1d1280f05543555917d161be399223e79d99f6fcacae6532bf" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    cp "resources/CMakeLists.txt", buildpath
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
  end
end
