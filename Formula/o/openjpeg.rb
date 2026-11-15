class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  license "BSD-2-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/uclouvain/openjpeg.git", branch: "master"

  stable do
    url "https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.5.4.tar.gz"
    sha256 "a695fbe19c0165f295a8531b1e4e855cd94d0875d2f88ec4b61080677e27188a"

    # TODO: Remove with the next release containing https://github.com/uclouvain/openjpeg/pull/1621.
    patch do
      url "https://github.com/uclouvain/openjpeg/commit/91d08b11a72764f6d199f32fa0c1b1abd4edc2ad.patch?full_index=1"
      sha256 "40648d63bfbb0f6c3a41cb9425ac48c396772c3527fff4b2979b07f42aaea6b8"
      type :backport
      resolves "OSV-2025-219"
    end

    # TODO: Remove with the next release containing https://github.com/uclouvain/openjpeg/pull/1628.
    patch do
      url "https://github.com/uclouvain/openjpeg/commit/839936aa33eb8899bbbd80fda02796bb65068951.patch?full_index=1"
      sha256 "d06af7a5e1681bb602e71bc1724718ff07f49aace9d841164658d72b1cfe7d5d"
      type :backport
      resolves "CVE-2026-6192"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "031d1267409505d3e26249e279633b21a55799c99ad7ce6cb0a8ede0fd8779fb"
    sha256 cellar: :any, arm64_tahoe:       "175f4e65750a8bc968e01b36259e7adb979dc32dbc22c0f4c980bb56e7b494b8"
    sha256 cellar: :any, arm64_sequoia:     "5f2c17c1be495ddc03d00c721b7144f63e9f5098cbee3147cb67610f3875a516"
    sha256 cellar: :any, arm64_linux:       "2ae24800fc442770c7db79ed9c62119f7a5dce67fc77f31511527544f56322be"
    sha256 cellar: :any, x86_64_linux:      "d76448f4df7eee17f227054562bc5df6d89342388ac6e496572fd7d901a4ad10"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_DOC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <openjpeg.h>

      int main () {
        opj_image_cmptparm_t cmptparm;
        const OPJ_COLOR_SPACE color_space = OPJ_CLRSPC_GRAY;

        opj_image_t *image;
        image = opj_image_create(1, &cmptparm, color_space);

        opj_image_destroy(image);
        return 0;
      }
    C
    system ENV.cc, "-I#{include.children.first}",
           testpath/"test.c", "-L#{lib}", "-lopenjp2", "-o", "test"
    system "./test"
  end
end
