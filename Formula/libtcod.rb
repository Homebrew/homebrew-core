class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "https://github.com/libtcod/libtcod"
  url "https://github.com/libtcod/libtcod/archive/1.20.1.tar.gz"
  sha256 "e36dccd1ad531503d1ceefe794a57b3b661e5e669c3d1db1d5bfaf0b95c933df"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ad5ff63a79a4dc88a396c2354a35069b1b6a071f1a74fe1bc1c7409cee7a3306"
    sha256 cellar: :any,                 arm64_big_sur:  "e0c79bd33806e5778030ed58f8713f20ba330abb8db1863e35a30fa296233986"
    sha256 cellar: :any,                 monterey:       "a48f8f4b894bf0bdf686e32b68aaec6f3c7b542b6ceb6e034fa28e3460653a84"
    sha256 cellar: :any,                 big_sur:        "b0b8a769e7517133a3b18afb736818f33f1f43bffa7e5bad6718d1d5b9a8b4a6"
    sha256 cellar: :any,                 catalina:       "42fae47e69489901101dd96237ee313752814f58a07f2470d00354e34b90eb72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b32e1acd83a46d4bad26511e01c4f13f405f503256b8228b6c235bc835e1625d"
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
