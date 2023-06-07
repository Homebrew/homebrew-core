class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.44.tar.gz"
  sha256 "3751c7fba8dbc831cb8d7cc8aff21035459b8ce5155ef8b0880a27d028475f3b"
  # libmagic has a BSD-2-Clause-like license
  license :cannot_represent

  livecheck do
    formula "file-formula"
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "f75b57b1eb21b7adae66433ab7fdc21ebc2d8140270f76be325d6fce3058c395"
    sha256 arm64_monterey: "f5367d8a930f6ac8bb72fab66d0596490e1fc33a7f723701492426812dca87d8"
    sha256 arm64_big_sur:  "a1a3b47eeeacdebbcf3a94f65ca27d995e60e867fae6bab8b2bd5b9774424f99"
    sha256 ventura:        "b010a3c8c7df5041caaff99ce844a9939f7f2529e4fe51e9817aa442a6949498"
    sha256 monterey:       "cf47bc2045224fc2c4dad701a80e7819883a447ee817d27a6197ff6fc751488d"
    sha256 big_sur:        "96bdcf33b2fd96db377b5a8952f56e7433bf17634b3e9cefef9b68ac775ca385"
    sha256 x86_64_linux:   "b0c07cbb8b16858ff3c762efe68dcb7be0f03139d40559e89766c104df06d6e4"
  end

  depends_on "pkg-config" => :test
  uses_from_macos "zlib"

  # Upstream patch for missing pkg-config stanza (https://bugs.astron.com/view.php?id=419)
  # Remove on next release
  patch do
    url "https://github.com/file/file/commit/8bc37a45bad67bc4604471c64f0c9f3372b55d2c.patch?full_index=1"
    sha256 "104f1854c93924dd1590049bf653b0cb9b57b269e7bf54d6a219a44c09011961"
  end

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
