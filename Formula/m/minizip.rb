class Minizip < Formula
  desc "C library for zip/unzip via zLib"
  homepage "https://www.winimage.com/zLibDll/minizip.html"
  url "https://zlib.net/zlib-1.3.2.tar.gz"
  sha256 "bb329a0a2cd0274d05519d61c667c062e06990d72e125ee2dfa8de64f0119d16"
  license "Zlib"
  revision 1
  compatibility_version 1

  livecheck do
    formula "zlib"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16451e526b90dcd6380df6003dec30796b9ebcc7fe8e62b9778a583e5b72cb47"
    sha256 cellar: :any,                 arm64_sequoia: "f90adff7167a19f53ef85ce23d46c5b5d016f58b9db126b02dc91c76a0fe744a"
    sha256 cellar: :any,                 arm64_sonoma:  "3e3f68961e5480e0d314a8db8978029bbd1315e6c00b909669456fa3693b1914"
    sha256 cellar: :any,                 sonoma:        "f6f4577f2f7c5d04fde8384f0ca43ee1cece548aa6abe0ae99b387058e79bbd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1d6d57105aa286c0347bc6a0dc3d80e86843e7c7b325467b8c1f76efd8a5dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8405db317fdfa195ffad20c51f5af22a0cc49c2076dd8f0b79f39ed5d5807222"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "unzip" => :test
  uses_from_macos "zip" => :test

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    cd "contrib/minizip" do
      system "autoreconf", "--force", "--install", "--verbose"
      system "./configure", *std_configure_args
      system "make", "install"
      # `ints.h` is required by `ioapi.h` but is not installed in zlib 1.3.2.
      # Remove once upstream includes it in releases:
      # https://github.com/madler/zlib/pull/1165
      (include/"minizip").install "ints.h"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <stdint.h>
      #include <minizip/unzip.h>

      static const char *zipname = "test.zip";

      int main(int argc, char **argv)
      {
          unzFile uzfile = unzOpen64(zipname);
          if (uzfile == NULL) {
              printf("Could not open %s for unzipping\\n", zipname);
              return 1;
          }

          do {
              unz_file_info64 finfo;
              char zfilename[256];
              char *string_method;
              int ret = unzGetCurrentFileInfo64(uzfile, &finfo, zfilename, sizeof(zfilename), NULL, 0, NULL, 0);
              if (ret != UNZ_OK) return ret;
              if (finfo.compression_method == 0) string_method = "Stored";
              else if (finfo.compression_method == Z_DEFLATED) {
                  uint16_t level = (uint16_t)((finfo.flag & 0x6) / 2);
                  if (level == 0)
                      string_method = "Defl:N";
                  else if (level == 1)
                      string_method = "Defl:X";
                  else if ((level == 2) || (level == 3))
                      string_method = "Defl:F";
                  else
                      string_method = "Unkn. ";
              } else if (finfo.compression_method == Z_BZIP2ED) string_method = "BZip2 ";
              else string_method = "Unkn. ";
              printf("%llu %s %llu %8.8lx %s\\n", finfo.uncompressed_size, string_method, finfo.compressed_size, finfo.crc, zfilename);
          } while (unzGoToNextFile(uzfile) != UNZ_END_OF_LIST_OF_FILE);
          return 0;
      }
    C

    system "zip", "-r", testpath/"test.zip", prefix
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lminizip", "-o", "test"

    test_results = shell_output(testpath/"test").lines.map(&:split)

    unzip_listing = shell_output("unzip -lv #{testpath}/test.zip").lines
    unzip_listing = unzip_listing.slice(3..(unzip_listing.length - 3))
    unzip_indices_to_keep = [0, 1, 2, 6, 7]
    unzip_results = unzip_listing.map do |item|
      item.split.select.with_index { |_, idx| unzip_indices_to_keep.include?(idx) }
    end

    assert_equal unzip_results, test_results
  end
end
