class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.15.1.tar.gz"
  sha256 "2713d8719be53db7a529cbf53064e5bc9f3adf009db339d3a81b50d471bc306f"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "03bed35243ebc9f4579cd1a7caf64400ce3d9123176d7b1b7ecf6f04e42292ac" => :catalina
    sha256 "cfb9de18466a896b671cc5fafdd7549297ae32887733142fe7c3d99e748399c9" => :mojave
    sha256 "aa57810f89ab4518d9e730fffbc885e46e1c8cede7b6877b066e001b14917fe0" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on :macos # Due to Python 2
  depends_on "sdl2"

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
    assert_equal "#{version}\n", `./version-c`
    (testpath/"version-cc.cc").write <<~EOS
      #include <libtcod/libtcod.hpp>
      int main()
      {
        std::cout << TCOD_STRVERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "-I#{include}", "-L#{lib}", "-ltcod", "version-cc.cc", "-o", "version-cc"
    assert_equal "#{version}\n", `./version-cc`
  end
end
