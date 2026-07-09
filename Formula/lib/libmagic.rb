class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.48.tar.gz"
  sha256 "ed14656883b23a364b4057c05595d93252da9bc473d30106519519d0da141283"
  license all_of: ["BSD-2-Clause-Darwin", "BSD-2-Clause", :public_domain]
  compatibility_version 1

  livecheck do
    formula "file-formula"
  end

  bottle do
    sha256 arm64_tahoe:   "c8c01258938e218cf9dcff85eaf7580b299821fab53f4d6706679d41d55b476b"
    sha256 arm64_sequoia: "c6e5827a76630cd9d8d7cb5ec0372c372cca1da5d80d4a578931020332ee3e88"
    sha256 arm64_sonoma:  "a581bb51e86bbc6fd8b8f8791a1cb5ba8794ced3c2dd567ab1c310b43a91f529"
    sha256 sonoma:        "5bc1a546f556add81790941a504fc0abaa83c08f2bec4a030e8528c3481152b2"
    sha256 arm64_linux:   "139b9039a0093c9a9c8d18566b9c0932f85f85389d0dfa65cd21ddd16d65be5a"
    sha256 x86_64_linux:  "506b8b31dfc6c4478ef078a281b3ed90d6fc9399b7f4625ba619df8a9d1e02b3"
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
