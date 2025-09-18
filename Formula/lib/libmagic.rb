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
    sha256 arm64_tahoe:   "fe356bfc03bc9d5eaeee4acdd54d1c0c13edf3645c6da7ea61831ba030a283ff"
    sha256 arm64_sequoia: "72bb18819cf63d14cdc3c830d586bd93e542f5cf2cdbbc579bfcd5170017fff1"
    sha256 arm64_sonoma:  "6c1bf60aeb9742e5c8c6973cbcc6ac970fbed9e255e6bbd479bd2f77513c0b46"
    sha256 arm64_ventura: "c619199785eaf8dda4ef65c9451fa7ca0fb5bab4452d108cb3d8669d53bec5fd"
    sha256 sonoma:        "76b116dbfc458b9c62623df89acb3b220500710823a18b604bd2add76c3ec6f6"
    sha256 ventura:       "b40e88d1e403b33e3544bac60b4ceda2524ae0ef0127c4c676211b83bffaa04f"
    sha256 arm64_linux:   "7654c8792fa33aece638f2b8efb56e33a6b86d2aa64c43bd65c39b0651e0e703"
    sha256 x86_64_linux:  "ad618acdc2587bb3d3e5d0c6022fff1c37c6c91b1c818ade50a026bf79469c73"
  end

  depends_on "pkgconf" => :test
  uses_from_macos "zlib"

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
