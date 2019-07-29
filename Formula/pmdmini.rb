class Pmdmini < Formula
  desc "Plays music in PC-88/98 PMD chiptune format"
  homepage "https://github.com/mistydemeo/pmdmini"
  url "https://github.com/mistydemeo/pmdmini/archive/v1.0.1.tar.gz"
  sha256 "5c866121d58fbea55d9ffc28ec7d48dba916c8e1bed1574453656ef92ee5cea9"

  bottle do
    cellar :any
    sha256 "fe87429ee546fa0629d178c52476c4cc5696abac76b21abcd3e4977c7527bd22" => :mojave
    sha256 "c3195012d5b5333e76c1a8a44b3f734575540deee884dfb6685e139e1038c138" => :high_sierra
    sha256 "59b287650c6e40c20da8000f5e73b910f8096bd949e4432b4f11e70b1c779a5d" => :sierra
    sha256 "72afd84c66fef9f142a1922fd0995a6a173b46c40d06715808345cc1c71b6702" => :el_capitan
  end

  depends_on "sdl"

  resource "test_song" do
    url "https://ftp.modland.com/pub/modules/PMD/Shiori%20Ueno/His%20Name%20Is%20Diamond/dd06.m"
    sha256 "36be8cfbb1d3556554447c0f77a02a319a88d8c7a47f9b7a3578d4a21ac85510"
  end

  def install
    # Specify Homebrew's cc
    inreplace "mak/general.mak", "gcc", ENV.cc
    system "make"

    # Makefile doesn't build a dylib
    system "#{ENV.cc} -dynamiclib -install_name #{lib}/libpmdmini.dylib -o libpmdmini.dylib -undefined dynamic_lookup obj/*.o"

    bin.install "pmdplay"
    lib.install "libpmdmini.a", "libpmdmini.dylib"
    (include+"libpmdmini").install Dir["src/*.h"]
    (include+"libpmdmini/pmdwin").install Dir["src/pmdwin/*.h"]
  end

  test do
    resource("test_song").stage testpath
    (testpath/"pmdtest.c").write <<~EOS
      #include <stdio.h>
      #include "libpmdmini/pmdmini.h"

      int main(int argc, char** argv)
      {
          char title[1024];
          pmd_init();
          pmd_play(argv[1], argv[2]);
          pmd_get_title(title);
          printf("%s\\n", title);
      }
    EOS
    system ENV.cc, "pmdtest.c", "-L#{lib}", "-lpmdmini", "-o", "pmdtest"
    result = `#{testpath}/pmdtest #{testpath}/dd06.m #{testpath}`.chomp
    assert_equal "mus #06", result
  end
end
