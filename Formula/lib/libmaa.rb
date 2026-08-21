class Libmaa < Formula
  desc "Low-level data structures including hash tables, sets, lists"
  homepage "https://dict.org/bin/Dict"
  url "https://downloads.sourceforge.net/project/dict/libmaa/libmaa-1.5.1/libmaa-1.5.1.tar.gz"
  sha256 "3a30e25f038e99c4715125545516490d991fe3a505825cc832b1a956e31bf669"
  license "MIT"
  head "https://github.com/cheusov/libmaa.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/libmaa[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "651f1943384f685d850d27769fb94b266046b62880c3112c15bf4d03ee3ad4c6"
    sha256 cellar: :any,                 arm64_sequoia:  "2b88aec983abd53f00f4fb93cae3234697551de075a45f36e8b4112d93f6dfcc"
    sha256 cellar: :any,                 arm64_sonoma:   "ffeb3a62fca07f8c095090d570b64165b442ab4e9debfab6475d7b6fdc2bdbe1"
    sha256 cellar: :any,                 arm64_ventura:  "90ab64584330817a8a5e11494945f1bcc67fac60733e4bea976d95a833341ce8"
    sha256 cellar: :any,                 arm64_monterey: "b3d1be0159e481318505912f1dd5e2d07e3d05122cf791e3743461595e2bd43b"
    sha256 cellar: :any,                 sonoma:         "92b9875c3fcae14b3bfa42df2d5cc47c87170f214f8e70eb5dd111e1fe1791ac"
    sha256 cellar: :any,                 ventura:        "05c6bb7f0a72131eb382e77c084dd3b26c34e58301fed77648c068b02c15da5d"
    sha256 cellar: :any,                 monterey:       "57325e2231ecbfd40349ab24d4841b433d41dd32d503aa9bbc484ee6954fc9c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a34cd9122ac279b62ac94ccc64d5525566dc526c49581f29f4ef4161f8247a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beb95d2918f10ee42290fb44faa0259e0e9f9e8a4f353822bcfee4268d3f5ef2"
  end

  depends_on "bmake" => :build
  depends_on "mk-configure" => :build

  def install
    system "mkcmake", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
      /* basetest.c -- Test base64 and base26 numbers
       * Created: Sun Nov 10 11:51:11 1996 by faith@dict.org
       * Copyright 1996, 2002 Rickard E. Faith (faith@dict.org)
       * Copyright 2002-2008 Aleksey Cheusov (vle@gmx.net)
       *
       * Permission is hereby granted, free of charge, to any person obtaining
       * a copy of this software and associated documentation files (the
       * "Software"), to deal in the Software without restriction, including
       * without limitation the rights to use, copy, modify, merge, publish,
       * distribute, sublicense, and/or sell copies of the Software, and to
       * permit persons to whom the Software is furnished to do so, subject to
       * the following conditions:
       *
       * The above copyright notice and this permission notice shall be
       * included in all copies or substantial portions of the Software.
       *
       * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
       * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
       * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
       * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
       * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
       * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
       * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
       *
       */

      #include <maa.h>
      #include <stdlib.h>

      int main( int argc, char **argv )
      {
         long int   i;
         const char *result;
         long int   limit = 0xffff;

         if (argc == 2) limit = strtol( argv[1], NULL, 0 );

         for (i = 0; i < limit; i++) {
            result = b26_encode( i );
            if (i != b26_decode( result )) {
         printf( "%s => %ld != %ld\\n", result, b26_decode( result ), i );
            }
            if (i < 100) {
         result = b26_encode( 0 );
         if (0 != b26_decode( result )) {
            printf( "%s => %ld != %ld (cache problem)\\n",
              result, b26_decode( result ), 0L );
         }
         result = b26_encode( i );
         if (i != b26_decode( result )) {
            printf( "%s => %ld != %ld (cache problem)\\n",
              result, b64_decode( result ), i );
         }
            }
            if (i < 10 || !(i % (limit/10)))
         printf( "%ld = %s (base26)\\n", i, result );
         }

         for (i = 0; i < limit; i++) {
            result = b64_encode( i );
            if (i != b64_decode( result )) {
         printf( "%s => %ld != %ld\\n", result, b64_decode( result ), i );
            }
            if (i < 100) {
         result = b64_encode( 0 );
         if (0 != b64_decode( result )) {
            printf( "%s => %ld != %ld (cache problem)\\n",
              result, b64_decode( result ), 0L );
         }
         result = b64_encode( i );
         if (i != b64_decode( result )) {
            printf( "%s => %ld != %ld (cache problem)\\n",
              result, b64_decode( result ), i );
         }
            }
            if (i < 10 || !(i % (limit/10)))
         printf( "%ld = %s (base64)\\n", i, result );
         }

         return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmaa", "-o", "test"
    system "./test"
  end
end
