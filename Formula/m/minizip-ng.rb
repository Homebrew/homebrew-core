class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.0.7.tar.gz"
  sha256 "a87f1f734f97095fe1ef0018217c149d53d0f78438bcb77af38adc21dff2dfbc"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d622ccfef83d7e940f3741faa660ea65a86b0b88607ad342c9cbf61b7d121908"
    sha256 cellar: :any,                 arm64_sonoma:   "34b1969b53e8f3432499789af0defac42027c440e32ba1df2a3e31d6a8fd87c5"
    sha256 cellar: :any,                 arm64_ventura:  "e03beb8fdeabfec130141c86e607020713357766aa2034a26eb373f82044c2bc"
    sha256 cellar: :any,                 arm64_monterey: "0a74f9330b6f34afc554840df5214649e920b0669c2f4b70235cdb1423bb4e9e"
    sha256 cellar: :any,                 sonoma:         "32999c125bdfb8e3e6f20a892f8c802ccddc192ed4b9e64f0cabfdbfe1d65f97"
    sha256 cellar: :any,                 ventura:        "d9ebd676a4d2ad996b0f8d9de8a30ca045552edb4fa381698b37da3c8d7d5295"
    sha256 cellar: :any,                 monterey:       "7e5f18ef56fe482184ace1a7686ea5d2d1e5423e92558c5b8c58566f53ee72d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2ed7856d5ac6319e6e9c09b86aded5d1361c2064296d0dda76c28be0f64692a"
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
