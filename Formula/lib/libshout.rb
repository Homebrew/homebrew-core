class Libshout < Formula
  desc "Data and connectivity library for the Icecast server"
  homepage "https://icecast.org/"
  url "https://ftp.osuosl.org/pub/xiph/releases/libshout/libshout-2.4.6.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/xiph/releases/libshout/libshout-2.4.6.tar.gz"
  sha256 "39cbd4f0efdfddc9755d88217e47f8f2d7108fa767f9d58a2ba26a16d8f7c910"
  license "LGPL-2.0-or-later"
  revision 4
  compatibility_version 1

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/libshout/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)libshout[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fcc1a1dc7239cdfcb515c1254c50c92281b29ba6dc5f3e447b0b18f69d746456"
    sha256 cellar: :any, arm64_tahoe:       "df51827d3fb5320177e4565522a8599a66beba94f81249834c43f5501105905a"
    sha256 cellar: :any, arm64_sequoia:     "b23ce4d41eab6778cb47172ddf05b60afb984c45d67730f5701336dd3637f553"
    sha256 cellar: :any, arm64_linux:       "3ace7fb3a6b171392149b0bb11490c4c6b450084ff98e75d757979bfb4ee7803"
    sha256 cellar: :any, x86_64_linux:      "af55f507eb92416a86626e64dd03dcefc0decbeebb4f68eaf3c9c2fb09bdf97b"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "openssl@4"
  depends_on "speex"
  depends_on "theora"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
  end

  deny_network_access!

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <shout/shout.h>

      int main(void) {
        shout_init();
        shout_t *shout = shout_new();
        if (shout == NULL) return 1;
        if (shout_set_host(shout, "127.0.0.1") != SHOUTERR_SUCCESS) return 1;
        printf("%s %s\\n", shout_version(NULL, NULL, NULL), shout_get_host(shout));
        shout_free(shout);
        shout_shutdown();
        return 0;
      }
    C
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("openssl@3")/"pkgconfig"
    pkgconf_flags = shell_output("pkgconf --cflags --libs shout").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkgconf_flags
    assert_equal "#{version} 127.0.0.1", shell_output("./test").strip
  end
end
