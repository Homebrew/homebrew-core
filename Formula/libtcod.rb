class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.20.0.tar.gz"
  sha256 "f7cf34167344770f24b427a9041d7f77ce49c47e1af4d087e022b79e7d53be38"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "51161dea3f3c60cc3b0006dee60b3018efbdb35136c0508a222868c5b3d8d5aa"
    sha256 cellar: :any, arm64_big_sur:  "824675da2dba07ef364cfd0cf2486d62931cacd351f905f4429217ca048cb132"
    sha256 cellar: :any, monterey:       "4af7d9c83f11fb46880a417df50f6df42162b3b692635ac2d812be1930318f94"
    sha256 cellar: :any, big_sur:        "6bd76abf88b3fed6345dcf4f1c0a1881d88c39d104d5b67c531d61a1f37b2491"
    sha256 cellar: :any, catalina:       "f3674fd5e50e37d66a3ea4bad2109e87c0d2ace43a08d81ddb71f86fa22b2925"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
