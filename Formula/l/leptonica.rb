class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.86.0/leptonica-1.86.0.tar.gz"
  sha256 "1fa08e40bb37fd45802d5e6e7b43927449a5c47d4608ef99d3bd3f0fa76baedc"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "373b3c03b29d240d7ebecb0b513b8829bb2fe7d2d8b1c27a1dd95cbe076487ca"
    sha256 cellar: :any,                 arm64_sequoia: "797df03f03bfa17345d7064ca4128d92943224c0a496ab77426b5a6710903348"
    sha256 cellar: :any,                 arm64_sonoma:  "56e1fae220bd7d340b66fd04409d9cf61c61d2a50866319caf02517452c85a77"
    sha256 cellar: :any,                 sonoma:        "f536e5d74cf3c967f33bc6ae9b55571961f81818590380bc4d58a331bc8e71f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f84cd2d6e6ea28c22b6bed9bad130e7af630c4d41a43a0b79c25b892d407979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "848250f50de5d83d97ffce88a6093a29fa01ea149b9e7ea3137ea480dce3ff81"
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
