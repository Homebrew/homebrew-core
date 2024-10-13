class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.44/libpng-1.6.44.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.44/libpng-1.6.44.tar.xz"
  sha256 "60c4da1d5b7f0aa8d158da48e8f8afa9773c1c8baa5d21974df61f1886b8ce8e"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "97e7780fa459489f57043430f53660e81c4bab4c0bd30b3c021ff8e1d1ae27ea"
    sha256 cellar: :any,                 arm64_sonoma:  "04c7ef0bb97718b8388e93e0e0f6a3e361da422b7f63f2a1f2bbb8ddb92da119"
    sha256 cellar: :any,                 arm64_ventura: "f17614f1c903db5ce208c3f78c3181377f121801fbeec50a53920591f0de4d34"
    sha256 cellar: :any,                 sonoma:        "3867ac12f43852e8e4b028b7cfbae1c7bbc2a4e3c36e7d7a7b1690c40392fd6d"
    sha256 cellar: :any,                 ventura:       "68f13a9e3ee84c0c50cb7d6d9d06a65287b3dcbc3baeb42ee7d2bcc1884a73d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf958f9647a35c402c463e78273a1bcd6e0dac715c1e949b03e876f2224d51e4"
  end

  head do
    url "https://github.com/glennrp/libpng.git", branch: "libpng16"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/libpng.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <png.h>

      int main()
      {
        png_structp png_ptr;
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
    system "./test"
  end
end
