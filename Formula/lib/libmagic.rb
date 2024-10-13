class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.45.tar.gz"
  sha256 "fc97f51029bb0e2c9f4e3bffefdaf678f0e039ee872b9de5c002a6d09c784d82"
  license all_of: ["BSD-2-Clause-Darwin", "BSD-2-Clause", :public_domain]

  livecheck do
    formula "file-formula"
  end

  bottle do
    sha256 arm64_sequoia:  "163d317bd1b513db98785b0c6b60b451dd4fb09e925ba61013147efd8fbc13a3"
    sha256 arm64_sonoma:   "4175e9bd00edb289020b1412fe1762554ccea7f5073050134995fc1578062341"
    sha256 arm64_ventura:  "ec5c143e70bff4635e77a831ac3a03a059d11fdf0512d37e6ab7de977dca8ad9"
    sha256 arm64_monterey: "a2e6411d29aaeff36e1e458fa9ac152d5f16a6093f8dd7c724c70da1afbd1f88"
    sha256 arm64_big_sur:  "3bbb6a6b220df55a5fcb8df54a170003d1dc4c7a3fbd3bd26a56f17ada8d0025"
    sha256 sonoma:         "41360c07f92f0a4ab86a78048f6c1fa74a0d1192b60ad45954d384d7606adada"
    sha256 ventura:        "81ae0df797e6cf1af040f0a99f446ff1ad2f8a8ca2a70d6b34c847996754a585"
    sha256 monterey:       "7d6b7e742b260e15df798b70e56f96a978aca56fe16777416bffec271bd077b6"
    sha256 big_sur:        "81c93a0805ef1e1a519988bf0c561bbcff058f9a129bec9691c4177505052bff"
    sha256 x86_64_linux:   "213f20f87112c4e7a6415baace66d49fdf165d96e8ca96c128e12745a1ea8862"
  end

  depends_on "pkg-config" => :test
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5",
                          "--enable-static"
    system "make", "install"
    (share/"misc/magic").install Dir["magic/Magdir/*"]

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <stdio.h>

      #include <magic.h>

      int main(int argc, char **argv) {
          magic_t cookie = magic_open(MAGIC_MIME_TYPE);
          assert(cookie != NULL);
          assert(magic_load(cookie, NULL) == 0);
          // Prints the MIME type of the file referenced by the first argument.
          puts(magic_file(cookie, argv[1]));
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs #{name}").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    cp test_fixtures("test.png"), "test.png"
    assert_equal "image/png", shell_output("./test test.png").chomp
  end
end
