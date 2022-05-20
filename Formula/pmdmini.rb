class Pmdmini < Formula
  desc "Plays music in PC-88/98 PMD chiptune format"
  homepage "https://github.com/mistydemeo/pmdmini"
  url "https://github.com/mistydemeo/pmdmini/archive/v1.0.1.tar.gz"
  sha256 "5c866121d58fbea55d9ffc28ec7d48dba916c8e1bed1574453656ef92ee5cea9"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "bd89f1d1b34981a1d1c10e1917a4303c8ce2937eeb25ab297cb9ab4868d82146"
    sha256 cellar: :any,                 big_sur:       "5778b030ba5ad8c7b850946f038729089893f5dd066d9d49fc23377da56a8bc3"
    sha256 cellar: :any,                 catalina:      "cfbf667e152bede1fce92c8d358195a651e807595bc5e704d71ee80cfe65682b"
    sha256 cellar: :any,                 mojave:        "fe87429ee546fa0629d178c52476c4cc5696abac76b21abcd3e4977c7527bd22"
    sha256 cellar: :any,                 high_sierra:   "c3195012d5b5333e76c1a8a44b3f734575540deee884dfb6685e139e1038c138"
    sha256 cellar: :any,                 sierra:        "59b287650c6e40c20da8000f5e73b910f8096bd949e4432b4f11e70b1c779a5d"
    sha256 cellar: :any,                 el_capitan:    "72afd84c66fef9f142a1922fd0995a6a173b46c40d06715808345cc1c71b6702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b3b2912d858cab1995fece6ba18b8bb80e111ace5184b322c37a3b0a2821e10"
  end

  depends_on "sdl"

  resource "test_song" do
    url "https://ftp.modland.com/pub/modules/PMD/Shiori%20Ueno/His%20Name%20Is%20Diamond/dd06.m"
    sha256 "36be8cfbb1d3556554447c0f77a02a319a88d8c7a47f9b7a3578d4a21ac85510"
  end

  def install
    # Specify Homebrew's cc
    inreplace "mak/general.mak", "gcc", ENV.cxx
    # Add -fPIC on Linux
    inreplace "mak/general.mak", "CFLAGS = -O2", "CFLAGS = -fPIC -O2" unless OS.mac?
    system "make"

    # Makefile doesn't build a dylib
    flags = if OS.mac?
      ["-dynamiclib",
       "-install_name", "#{lib}/libpmdmini.dylib",
       "-undefined", "dynamic_lookup"]
    else
      ["-shared"]
    end

    system ENV.cxx, *flags, "-o", shared_library("libpmdmini"), *Dir["obj/*.o"]

    bin.install "pmdplay"
    lib.install "libpmdmini.a", shared_library("libpmdmini")
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
