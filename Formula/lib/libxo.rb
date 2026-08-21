class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://github.com/Juniper/libxo/releases/download/2.0.0/libxo-2.0.0.tar.gz"
  sha256 "982de1877309dd9d57f4cabf2c8bbf42c1c15dc402cd8586ab1e4eabaea298eb"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_tahoe:   "953e91c12c927736357428136d2403b1e2d610e1d3e8fd557fd7878759d18aa4"
    sha256 arm64_sequoia: "c8250f122d0d6741448070f5c0eccd4beecf5a6b1315a4acc1bceb6be3f92588"
    sha256 arm64_sonoma:  "be39da316cca8f97ef0c4c226dd6b4c56a03393bd3ba1b33c1d92d71846d89ba"
    sha256 sonoma:        "764b52990cd9477f2e6c0e6665270a2d6b2528b8b5ce5053f9d734e1f23eb4c3"
    sha256 arm64_linux:   "ee547be31bd6316d94d32176ee7c6d0ab7664f628c328338f3282e5e8a631986"
    sha256 x86_64_linux:  "39d3eea6c0f848ddf09757a8a79113bd8d1b116315208018899b4d15f212f06f"
  end

  depends_on "libtool" => :build
  depends_on "gettext"

  on_linux do
    # The XPath parser is generated with byacc-only options (`-P`, `-s`); the
    # `yacc` on Linux is bison, which rejects them.
    # Upstream fix: https://github.com/Juniper/libxo/pull/116
    depends_on "byacc" => :build
  end

  def install
    # `bool` is used as an identifier, which C23 no longer allows
    ENV["ac_cv_prog_cc_c23"] = "no"
    # Nothing uses libcrypto, but finding it adds -lcrypto to every link
    ENV["ac_cv_lib_crypto_MD5_Init"] = "no"

    # libxo uses `bool` as an identifier; GCC 15+ defaults to C23 where it is a
    # keyword, and `ac_cv_prog_cc_c23=no` only stops configure adding `-std=c23`.
    # Upstream fix: https://github.com/Juniper/libxo/pull/116
    ENV.append_to_cflags "-std=gnu17" if OS.linux?

    # glibc provides gettext in libc and ships no `libintl`, so the `-lintl`
    # detection fails and the (ungated) msgfmt check aborts. Make it non-fatal;
    # libxo then builds without gettext, as it did before 2.0.0.
    # Upstream fix: https://github.com/Juniper/libxo/pull/116
    if OS.linux?
      inreplace "configure", 'as_fn_error $? "\"could not find msgfmt tool\"',
                             ': $? "\"could not find msgfmt tool\"'
    end

    # configure only looks for gettext in /usr, /opt/local and /usr/local
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gettext=#{formula_opt_prefix("gettext")}",
                          "--prefix=#{prefix}"

    # The generated `xo_xpath.tab.h` has no ordered prerequisite on the objects
    # that include it, which races under parallel make.
    # Upstream fix: https://github.com/Juniper/libxo/pull/116
    ENV.deparallelize

    # glibc 2.38+ has `strlcpy` but does not declare it, so libxo leaves it
    # undefined in `libxo.so`; resolve it at load time (keeping the `-ldl` the
    # Makefile sets). Not needed on macOS, where `strlcpy` is in libc.
    # Upstream fix: https://github.com/Juniper/libxo/pull/116
    if OS.linux?
      system "make", "install", "LDFLAGS=-ldl -Wl,--allow-shlib-undefined"
    else
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libxo/xo.h>
      int main() {
        xo_set_flags(NULL, XOF_KEYS);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxo", "-o", "test"
    system "./test"
  end
end
