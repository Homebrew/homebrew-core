class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.47.tar.gz"
  sha256 "45672fec165cb4cc1358a2d76b5d57d22876dcb97ab169427ac385cbe1d5597a"
  license all_of: ["BSD-2-Clause-Darwin", "BSD-2-Clause", :public_domain]
  compatibility_version 1

  livecheck do
    formula "file-formula"
  end

  bottle do
    sha256 arm64_tahoe:   "f7aa29830da3062c82a1573bcadb35df0951de214d908543db23f89d55fdb831"
    sha256 arm64_sequoia: "6f52d18caa98d2f3aee461cff07e20ee353476e5612bad6ab0865f5d0b90921b"
    sha256 arm64_sonoma:  "8fb3f8f7fdd14723f494b82c85a7c83fdedaf88a042d8c33dae09ed02e2382ae"
    sha256 sonoma:        "b386f869ea612420b8835424308c886c7ce72667b1e9e41d08fb8358daa918cb"
    sha256 arm64_linux:   "c66a9827c4498d168f68346243ea5ab6772b9a707b9a79dadccb59f5ec847574"
    sha256 x86_64_linux:  "2fd518dd644a4e1b94cde7150b7d1d7f24403940a20c0a175dda85465d207b99"
  end

  depends_on "pkgconf" => :test

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-fsect-man5",
                          "--enable-static",
                          *std_configure_args
    system "make", "install"
    (share/"misc/magic").install Dir["magic/Magdir/*"]

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    flags = shell_output("pkgconf --cflags --libs #{name}").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    cp test_fixtures("test.png"), "test.png"
    assert_equal "image/png", shell_output("./test test.png").chomp
  end
end
