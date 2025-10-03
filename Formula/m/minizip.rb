class Minizip < Formula
  desc "C library for zip/unzip via zLib"
  homepage "https://www.winimage.com/zLibDll/minizip.html"
  url "https://zlib.net/zlib-1.3.1.tar.gz"
  sha256 "9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23"
  license "Zlib"

  livecheck do
    formula "zlib"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "071d707964738d0320bbbab807f7e47a7fe3e2ef8e4f32ef71d969f98d5cda0b"
    sha256 cellar: :any,                 arm64_sequoia:  "3641776397e76574fcfe89466a78fd4dfedf9318a3c773fbfaffb0f0ec696547"
    sha256 cellar: :any,                 arm64_sonoma:   "3bc53490be71be5fcf8c018ba2db9b061dbedf50a12c6f6fabcc9f4df003cfc5"
    sha256 cellar: :any,                 arm64_ventura:  "d60c0678b1ac599448e1dd216aa3e44a9b9f11c00bfd7271eaa5c9e4296a3ad4"
    sha256 cellar: :any,                 arm64_monterey: "437e23f93e1777d4b4f4d849bc6026361ba46591ba8081d8ab289a3d6dba45c3"
    sha256 cellar: :any,                 sonoma:         "927f46afb50e1cef0f6c7024cea807025835379984c786d8a17ceef071a2367f"
    sha256 cellar: :any,                 ventura:        "17ea4d0486f352f08d526f54149cc61351456325a2f49cd2a5e85f43a5c8180a"
    sha256 cellar: :any,                 monterey:       "fda3b687c8bf4b06f369ec2c43e2fba4fa08d0a8d80ca46b605cf79e18ea0c50"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7c65b8c1da154f8f300b063166a03dbef658a3f118536476240447c28cc81e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "031048178895f72541584dabaa7b5606b9fbbbdeaf4dfcc7aeccfe0a05fcf4ee"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "unzip" => :test
  uses_from_macos "zip" => :test
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    cd "contrib/minizip" do
      if OS.mac?
        # edits to statically link to libz.a
        inreplace "Makefile.am" do |s|
          s.sub! "-L$(zlib_top_builddir)", "$(zlib_top_builddir)/libz.a"
          s.sub! "-version-info 1:0:0 -lz", "-version-info 1:0:0"
          s.sub! "libminizip.la -lz", "libminizip.la"
        end
      end
      system "autoreconf", "--force", "--install", "--verbose"
      system "./configure", *std_configure_args
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      Minizip headers installed in 'minizip' subdirectory, since they conflict
      with the venerable 'unzip' library.
    EOS
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
