class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.15.1.tar.gz"
  sha256 "2713d8719be53db7a529cbf53064e5bc9f3adf009db339d3a81b50d471bc306f"
  license "BSD-3-Clause"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "464855bc6a479110433503a085c22f0bd8c2389875334595f9e525528982c1c3" => :big_sur
    sha256 "2307306cad3fe74920216768953f8b2ba6721a49d1738870f7b2ccbab8a2691e" => :arm64_big_sur
    sha256 "0ac1dde6fa975c1504880848ba2ec66dd0d044c5cfeccb92d3afe4f6ebb8231a" => :catalina
    sha256 "e076b9fe253e60fc065493cab467d30c4db178d9364e410a3c7cf71293df7cf0" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
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
