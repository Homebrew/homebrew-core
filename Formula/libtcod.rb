class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.19.0.tar.gz"
  sha256 "37c9dff5eb61be1aa4dc08f6c7fe910385e12244c14c6b163e2ffab373d779d7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "eb25fc002f492d38ed3a8acefa9b2c8af6b538b0c61e8d7ba76456c161a0902b"
    sha256 cellar: :any, arm64_big_sur:  "1fab6b1ff1ee7f9ab0ded5b89867f4250b882445ffef5c73b20348227abdd00f"
    sha256 cellar: :any, monterey:       "d7cb93d38458e8d83b7b61b6dfb5c65e16965572cb40f0e60d9b3809a8bfabde"
    sha256 cellar: :any, big_sur:        "0110681440d6825ef184dea27219a190126ab176d5e278c5d27c2e38c33444f5"
    sha256 cellar: :any, catalina:       "55e5e93eb87f3e7b7df2fdaa497b8888bf899139b4cad0cb1c1790eeed77bb6b"
    sha256 cellar: :any, mojave:         "b9b4bd6b64f52cac8e09e7263caed4bad328eae3a58e3e43cba7b50a957c1371"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "sdl2"

  conflicts_with "libzip", "minizip-ng", because: "libtcod, libzip and minizip-ng install a `zip.h` header"

  def install
    cd "buildsys/autotools" do
      system "autoreconf", "-fiv"
      system "./configure"
      system "make"
      lib.install Dir[".libs/*{.a,.dylib}"]
    end
    Dir.chdir("src") do
      Dir.glob("libtcod/**/*.{h,hpp}") do |f|
        (include/File.dirname(f)).install f
      end
    end
    # don't yet know what this is for
    libexec.install "data"
  end

  test do
    (testpath/"version-c.c").write <<~EOS
      #include <libtcod/libtcod.h>
      #include <stdio.h>
      int main()
      {
        puts(TCOD_STRVERSION);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ltcod", "version-c.c", "-o", "version-c"
    assert_equal version.to_s, shell_output("./version-c").strip
    (testpath/"version-cc.cc").write <<~EOS
      #include <libtcod/libtcod.hpp>
      #include <iostream>
      int main()
      {
        std::cout << TCOD_STRVERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "-I#{include}", "-L#{lib}", "-ltcod", "version-cc.cc", "-o", "version-cc"
    assert_equal version.to_s, shell_output("./version-cc").strip
  end
end
