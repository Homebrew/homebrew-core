class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.85.0/leptonica-1.85.0.tar.gz"
  sha256 "3745ae3bf271a6801a2292eead83ac926e3a9bc1bf622e9cd4dd0f3786e17205"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d2d966918337ee5feda18544d4546734f77aeaf4dde87ae8979589bd97c799c1"
    sha256 cellar: :any,                 arm64_sonoma:  "4b742a3445f7a24454ebf897551b8d49fc5cdc2ab7c93fc5a5c6ec4695292ef0"
    sha256 cellar: :any,                 arm64_ventura: "c63d4257101ed2af4aca050ce013a6825ca189ec0f4cea03bdd650ecea77cc71"
    sha256 cellar: :any,                 sonoma:        "97b295e17239dca10dbc284995b439594ad857afa84b9e81b12b6dd597e8daa8"
    sha256 cellar: :any,                 ventura:       "b85f75996d77b388e32d762a3b5c9d70f6a4d6be088353822b57b52c71a4d8b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1337f4e47a28be51760dc07833dd60892c01687e62cdcbe04dffec94f5fb20fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b2c01e724c093ba4b4bf19bdd65edcc3ff70dbc5071e5e801f07b9f24cc2d63"
  end

  depends_on "pkgconf" => :build
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "webp"

  uses_from_macos "zlib"

  def install
    system "./configure", "--with-libwebp", "--with-libopenjpeg", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <leptonica/allheaders.h>

      int main(int argc, char **argv) {
          fprintf(stdout, "%d.%d.%d", LIBLEPT_MAJOR_VERSION, LIBLEPT_MINOR_VERSION, LIBLEPT_PATCH_VERSION);
          return 0;
      }
    CPP

    flags = ["-I#{include}/leptonica"] + ENV.cflags.to_s.split
    system ENV.cxx, "test.cpp", *flags
    assert_equal version.to_s, shell_output("./a.out")
  end
end
