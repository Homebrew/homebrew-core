class Libconfini < Formula
  desc "Yet another INI parser"
  homepage "https://madmurphy.github.io/libconfini/"
  url "https://github.com/madmurphy/libconfini/releases/download/1.16.4/libconfini-1.16.4-with-configure.tar.gz"
  sha256 "f4ba881e68d0d14f4f11f27c7dd9a9567c549f1bf155f4f8158119fb9bc9efd6"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "eb8f8042903c062720e17741771d92b7c53aafba9642780f0ccda86f6abf2c80"
    sha256 cellar: :any,                 arm64_sequoia:  "fbb299d21214fdc73d660ee6cc61ea6a6aff2d85558db6095558be0202c30440"
    sha256 cellar: :any,                 arm64_sonoma:   "34cbf810ecbd056e906847dafb23c8a8dba3d6f1af918c1a99e9b278b5c0af84"
    sha256 cellar: :any,                 arm64_ventura:  "6bdad3efe351d8dd2c80092ddcbeee38766d1a5cdc28b8ab797279bdb6af411a"
    sha256 cellar: :any,                 arm64_monterey: "1909d5da9729d0787b5178444f5da844a389c143f810edee022bec357f7d29a3"
    sha256 cellar: :any,                 sonoma:         "805ea288421a60b74cfe73fac192319c29a405dc634940c0f21e50094db6faeb"
    sha256 cellar: :any,                 ventura:        "0a41e42e70833201fc9cf7689489981aa3befb03fcd01fabdf0615636f0987a8"
    sha256 cellar: :any,                 monterey:       "4c8e5280349538270ca6ae1ccf257a27bc0232b26573415ffc5841838c161350"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f8cebbb4371e80a06465b9bbd9e33973b8f752b529979c99a40911e665cd32dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f5987375e6a2d5de8d24c0dcb1dc175fa778fd52fd0000ca213ba989a6d42fc"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.ini").write "[users]\nknown_users = alice, bob, carol\n"
    (testpath/"test.c").write <<~C
      #include <confini.h>

      static int callback (IniDispatch * disp, void * v_other) {
        #define IS_KEY(SECTION, KEY) \
          (ini_array_match(SECTION, disp->append_to, '.', disp->format) && \
          ini_string_match_ii(KEY, disp->data, disp->format))
        if (disp->type == INI_KEY) {
          if (IS_KEY("users", "known_users")) {
            printf("Known Users: %s\\n", disp->value);
          }
        }
        #undef IS_KEY
        return 0;
      }

      int main () {
        if (load_ini_path("test.ini", INI_DEFAULT_FORMAT, NULL, callback, NULL)) {
          fprintf(stderr, "Error while loading test.ini\\n");
          return 1;
        }
        return 0;
      }
    C

    system ENV.cc, testpath/"test.c", "-I#{include}", "-L#{lib}", "-lconfini", "-o", "test"
    assert_match "Known Users: alice, bob, carol", shell_output(testpath/"test").chomp
  end
end
