class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.0.1.tar.gz"
  sha256 "6cc20a20e3ab53ce485ccf6e044a30141b3d62cf7743b83bb04906ff29453035"
  license "CECILL-2.1"
  head "https://github.com/dtschump/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/files/source/"
    regex(/href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c4695a687fe50770a04247de2b403f5baecb1ab1ce71646bdcf90483046377d8"
    sha256 cellar: :any,                 arm64_big_sur:  "eae7c4b071fd61a508978708ded5ab272d43634122b7480566b369bee918e84b"
    sha256 cellar: :any,                 monterey:       "e0360d49276b222dca348523b08f72406d57ae92085c8ad7240a905230bc60fd"
    sha256 cellar: :any,                 big_sur:        "efe20f281b18e825d282c0672f9b4bd525cac7d6e2dd971213ab95c1db555ee5"
    sha256 cellar: :any,                 catalina:       "864e83816816e75e1f39a7f448d5e1cc204073956806cdfcbc289a78f52ba220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e61637e97caf2fdd854f10c685ef304731a607a8a4e0161d49b0dcfeeac08ef"
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
