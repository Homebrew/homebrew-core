class Libmaa < Formula
  desc "Low-level data structures including hash tables, sets, lists"
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/libmaa/libmaa-1.4.4/libmaa-1.4.4.tar.gz"
  sha256 "fbd739e8467c4b7213594b172cfe3059443127313f8365224aa9c269498869e2"

  bottle do
    cellar :any
    sha256 "a56c7ab86ee8c313db35d4e79afae1b3692861342d38285131df70b45c6de7bb" => :mojave
    sha256 "38ce8dcaa6938bc3395b1d77a6024b72ddea32f1cbeea4cb5f3cfabc432149ee" => :high_sierra
    sha256 "c224bcb3cbf442e4f6f01bae2ec3487877b81af0e93b6bb8cb16ad2f6012a1b6" => :sierra
  end

  depends_on "bmake" => :build
  depends_on "mk-configure" => :build

  def install
    system "mkcmake", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmaa", "-o", "test"
    system "./test"
  end
end
