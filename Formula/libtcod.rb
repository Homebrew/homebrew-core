class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.22.1.tar.gz"
  sha256 "0196797ffe4b76df157c3d70578d7f060345cd2323ebe8cca3717867dd85496e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "295fc5d7cb7b28d5cb27ecacf4df3ec3a070095056425834bec9da424dc90530"
    sha256 cellar: :any,                 arm64_big_sur:  "ee75d00fbbee426cbcde881fa5b4ccca5413230831f8ba04467bb8d968c66968"
    sha256 cellar: :any,                 monterey:       "3e460bb77a31fe2760071ced8f96e881e8a73d96388463b54171cf513282a56c"
    sha256 cellar: :any,                 big_sur:        "06afc0e1c0313023abcb8ff33865225df5196c7d5f1c9987826497a14301aa6c"
    sha256 cellar: :any,                 catalina:       "92e61ba0917a8ab7ed60105024944bde1f87597e450554976dfb00eacea1a269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bc4b15c7afd85b21a2ee81ec66924e8925dd3cfdcd39c0dc29733353c1d221e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on macos: :catalina
  depends_on "sdl2"

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "libzip", "minizip-ng", because: "libtcod, libzip and minizip-ng install a `zip.h` header"

  fails_with gcc: "5"

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
