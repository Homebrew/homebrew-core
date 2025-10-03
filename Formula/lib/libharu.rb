class Libharu < Formula
  desc "Library for generating PDF files"
  homepage "https://github.com/libharu/libharu"
  url "https://github.com/libharu/libharu/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "0ed3eacf3ceee18e40b6adffbc433f1afbe3c93500291cd95f1477bffe6f24fc"
  license "Zlib"
  head "https://github.com/libharu/libharu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f59e3e3a39098aa5c4816aafe8b48c6bc1a86645bc8ac6bd5dbbb258feee2249"
    sha256 cellar: :any,                 arm64_sequoia: "9c7a27f6e339997261bedf2c177bc414e108390ad21eee1a102f855183b2d8f1"
    sha256 cellar: :any,                 arm64_sonoma:  "5830f3184260a06dadbea0233a05bdcc1cf2c5d0f53291f985dca7511963fccd"
    sha256 cellar: :any,                 arm64_ventura: "370df233f9ade42e8febcc4563eb80e6e112c553474d86ae9707519d2875f20a"
    sha256 cellar: :any,                 sonoma:        "c0f5f184237e5b4351a2d79b3c301a4d70483bc678665524298048941938d166"
    sha256 cellar: :any,                 ventura:       "599507ae5f1714845532e3499bd1206e3bb0736d218494ba897a723db02e9d1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0148393272b8a77a9a0cd78e685b99c1949c153ecc965789e34f3be4ad6bf1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "111c4ee131b6aa6e5126b9c223ea209f12de631932c1db0e02f70a1002fdde58"
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
    lib.install "build-static/src/libhpdf.a"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lhpdf", "-lz", "-lm", "-o", "test"
    system "./test"
  end
end
