class Libharu < Formula
  desc "Library for generating PDF files"
  homepage "https://github.com/libharu/libharu"
  url "https://github.com/libharu/libharu/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "d1c38c0492257c61fb60c85238d500c05184fd8e9e68fecba9cf304ff2d8726d"
  license "Zlib"
  head "https://github.com/libharu/libharu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7920390e4d600caeb98186b701f46b79988a780d79cb6884c799cfd7f2a77152"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1c428d9f3440b10ffdd2da58c8e12388b0bf2b5848574a96d118db9a7507417"
    sha256 cellar: :any_skip_relocation, monterey:       "8c74e19763e520f70c9a896bf97a10fba52ae94c7407c68937bdd4f5dc13e3b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "44a1d030f0a176aae7d546787d5d36be80c027eedf12d410864e32e8a8258e4d"
    sha256 cellar: :any_skip_relocation, catalina:       "84ab7bb3db472c529a02ce4746b907aa9ba80c13379420b2e50cea1a892c8d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad3a1c7359b0807323ff595bd84e5c316a4e32bc1ff921833630caa837d629f7"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  uses_from_macos "zlib"

  def install
    # Build shared library
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Build static library
    system "cmake", "-S", ".", "-B", "build-static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build-static"
    lib.install "build-static/src/libharu.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "hpdf.h"

      int main(void)
      {
        int result = 1;
        HPDF_Doc pdf = HPDF_New(NULL, NULL);

        if (pdf) {
          HPDF_AddPage(pdf);

          if (HPDF_SaveToFile(pdf, "test.pdf") == HPDF_OK)
            result = 0;

          HPDF_Free(pdf);
        }

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lharu", "-lz", "-lm", "-o", "test"
    system "./test"
  end
end
