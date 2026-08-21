class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://ecl.common-lisp.dev"
  url "https://ecl.common-lisp.dev/static/files/release/ecl-26.5.5.tgz"
  sha256 "a01a5bcda8c5b73e59dda3494fd13e5fec5db6aa1dad782c3cc3bb57f1633435"
  license "LGPL-2.1-or-later"
  head "https://gitlab.com/embeddable-common-lisp/ecl.git", branch: "develop"

  livecheck do
    url "https://ecl.common-lisp.dev/static/files/release/"
    regex(/href=.*?ecl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256 arm64_tahoe:   "79f4778027f26a5ed162a672840d50acd347aeaa73ebb94d66cbd072f048e060"
    sha256 arm64_sequoia: "dbc7411cb1d7d85e211fbfcb1ac245fb077312b194394ef5b7879a389a3a4d3b"
    sha256 arm64_sonoma:  "29b32f9bf4fc09206f8e3b08ded8b0bdb08167963a80ff3330077db4a8a2d952"
    sha256 sonoma:        "b8f6d1d2b0eedb0cb27e8adc1847bcd0e27c32e59e22a0e5b1807b205bdd4c9d"
    sha256 arm64_linux:   "583cab74ee2c1a7b85a1c10b67228e39d66447cc160c6d8c38867ba31f5608b5"
    sha256 x86_64_linux:  "6ffe0230d65fc695a539c69fc98d11edd4e71425bba8f9db50ff3aa64f530fff"
  end

  depends_on "texinfo" => :build # Apple's is too old
  depends_on "bdw-gc"
  depends_on "gmp"

  uses_from_macos "libffi"

  # does not build on macOS 14
  on_macos do
    on_intel do
      depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600

      fails_with :clang do
        build 1600
        cause "Unhandled lisp initialization error"
      end
    end
  end

  patch do
    url "https://gitlab.com/embeddable-common-lisp/ecl/-/commit/59de50b52380132d44bfa05f573544cba0a8c65f.diff"
    sha256 "553982804178fbcc3111474e8ca5319c689141e74c151f3feb6fec78f93ae640"
    type :backport
  end

  def install
    ENV.deparallelize

    libffi_prefix = if OS.mac?
      MacOS.sdk_path
    else
      formula_opt_prefix("libffi")
    end
    system "./configure", "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system",
                          "--with-gmp-prefix=#{formula_opt_prefix("gmp")}",
                          "--with-libffi-prefix=#{libffi_prefix}",
                          "--with-libgc-prefix=#{formula_opt_prefix("bdw-gc")}",
                          "--with-extra-files=#{buildpath}/src/util/side-modules.lsp",
                          *std_configure_args
    ENV["ECL_SIDE_MODULES_PATH"] = "#{HOMEBREW_PREFIX}/lib/ecl-#{version}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"simple.cl").write <<~LISP
      (write-line (write-to-string (+ 2 2)))
    LISP
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
