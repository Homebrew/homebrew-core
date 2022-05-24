class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.41.tar.gz"
  sha256 "13e532c7b364f7d57e23dfeea3147103150cb90593a57af86c10e4f6e411603f"
  # libmagic has a BSD-2-Clause-like license
  license :cannot_represent

  livecheck do
    formula "file-formula"
  end

  bottle do
    sha256 arm64_monterey: "35178fd8f00c95f6f576cb98809ba1a8778c4ff6afb3fd5dafe5122fb9172188"
    sha256 arm64_big_sur:  "b851d23643cbb4558264dce05ae04afb67188753ed9631707ba24177f4d8b618"
    sha256 monterey:       "e77cc066068ef97ec61fdecd1c59229baad49e82aac3be24d8b1cce37cac0045"
    sha256 big_sur:        "90a9c204356d026e45f276ff7466b2afe11593b8992ae2f4e199951d973124a7"
    sha256 catalina:       "bd9af8b940362c68313c49ea0481e8b705514fd558582cfa609548aea3e03b01"
    sha256 mojave:         "ee176ca0e970104d6f4d59c752e9ce94433b1ae4e09ae12bdd5daf45e2a332f1"
    sha256 x86_64_linux:   "045b433b1e5ce7a3adf028ce87dd03b8a28255cad4547ec318772b242523080d"
  end

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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmagic", "-o", "test"
    cp test_fixtures("test.png"), "test.png"
    assert_equal "image/png", shell_output("./test test.png").chomp
  end
end
