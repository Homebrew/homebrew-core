class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.46.tar.gz"
  sha256 "c9cc77c7c560c543135edc555af609d5619dbef011997e988ce40a3d75d86088"
  license all_of: ["BSD-2-Clause-Darwin", "BSD-2-Clause", :public_domain]

  livecheck do
    formula "file-formula"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "60c4369478387e3bba7bc67a482f8e88afc652fd34862cda457dfe9654f64227"
    sha256 arm64_sequoia: "51ee0b5206fbbae1221e925cc365d62c41924533391e9bcd74fbb85c26903318"
    sha256 arm64_sonoma:  "6a577d4cfa044db8d2591f9b018fc84124ae033356147ac635c9566000950c17"
    sha256 sonoma:        "807ceb6299673e99147e9cb7314fe88aeda5da6d74caabab710b626c10d3a58f"
    sha256 arm64_linux:   "e7e76d51ea86c02ad1ede72958e3a132799ae8674aa115101f8190dd4fe663e2"
    sha256 x86_64_linux:  "ea3faa725738b000ec5e1be6b41b8f139b38b2205f2a0849a8b5bc92f5e2f16d"
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
