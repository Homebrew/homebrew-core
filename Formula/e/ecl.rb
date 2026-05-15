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
    sha256 arm64_tahoe:   "054ff824a33ca7a35e66bc33dba30390f2c7b72f0405b9778603f889ce06c260"
    sha256 arm64_sequoia: "33efb093034b0c7ac433e63bbdfd11b216ebda96cf07ecad294eab1ad7cad2a8"
    sha256 arm64_linux:   "a19e6405f0f7b7b25e7792d7d19a66f01b3276c115cf09a74559794cde45fb4e"
    sha256 x86_64_linux:  "d4f53f9ae623f0997d4395a3967c84151bf168ad76dd815e705c4be41a86d008"
  end

  depends_on "texinfo" => :build # Apple's is too old
  depends_on "bdw-gc"
  depends_on "gmp"

  uses_from_macos "libffi"

  on_macos do
    depends_on macos: :sequoia
  end

  # does not build on macOS 14

  def install
    ENV.deparallelize

    libffi_prefix = if OS.mac?
      MacOS.sdk_path
    else
      Formula["libffi"].opt_prefix
    end
    system "./configure", "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-libffi-prefix=#{libffi_prefix}",
                          "--with-libgc-prefix=#{Formula["bdw-gc"].opt_prefix}",
                          *std_configure_args
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
