class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.0.6.tar.gz"
  sha256 "e96ed3866706a67dbed05bf035e26ef6b60f408e1381bf0fe9af17fe2c0abebc"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "81ab9b504997cad1e44a9e6bcccc832cc2484c459fa86595afe75cc55de2365f"
    sha256 cellar: :any,                 arm64_ventura:  "c560cda9cb84b5a7b0149d9012a8ddbbfc5cc71544e362e5292d1ea361335655"
    sha256 cellar: :any,                 arm64_monterey: "3a3a8c47b9f4e6ca14a2372be02196703f1652c94ded15cadee0a1fdc94de587"
    sha256 cellar: :any,                 sonoma:         "55a0b92b6704583c3784c5086f79c6968e2dcb98dfd77116893220f78f718ad7"
    sha256 cellar: :any,                 ventura:        "21c522b520eef8cadabadc51eb22691c578e617d6d92f0e4d15da0b7fdfb6820"
    sha256 cellar: :any,                 monterey:       "b31ca8086e68ddf32b6390e276434bf24cb4d2ef3151c3ebced32b367aac172e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "799e1d23b8c6168c771df13e2b2bb583b28d83b6cb3611ca555b06f69c26bef4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    args = %w[
      -DMZ_FETCH_LIBS=OFF
      -DMZ_LIB_SUFFIX=-ng
      -DMZ_LIBCOMP=OFF
      -DMZ_ZLIB=ON
    ]

    system "cmake", "-S", ".", "-B", "build/shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libminizip-ng.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <stdint.h>
      #include <time.h>
      #include "mz_zip.h"
      #include "mz_compat.h"
      int main(void)
      {
        zipFile hZip = zipOpen2_64("test.zip", APPEND_STATUS_CREATE, NULL, NULL);
        return hZip != NULL && mz_zip_close(NULL) == MZ_PARAM_ERROR ? 0 : 1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}/minizip-ng", "-L#{lib}", "-lminizip-ng", "-o", "test"
    system "./test"
  end
end
