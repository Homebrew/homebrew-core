class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://ecl.common-lisp.dev"
  url "https://ecl.common-lisp.dev/static/files/release/ecl-23.9.9.tgz"
  sha256 "c51bdab4ca6c1173dd3fe9cfe9727bcefb97bb0a3d6434b627ca6bdaeb33f880"
  license "LGPL-2.1-or-later"
  head "https://gitlab.com/embeddable-common-lisp/ecl.git", branch: "develop"

  livecheck do
    url "https://ecl.common-lisp.dev/static/files/release/"
    regex(/href=.*?ecl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "fcb80a9c5cc2669190d6d58450dfee2d223cc6b27da6932b644d7e79ba015049"
    sha256 arm64_ventura:  "66aab9a69955ac7e8ffa8333c123f95b07f9d3255a44ba92190de1bf9652c393"
    sha256 arm64_monterey: "b1b8a622d7ec1cd1962ac43dd18837380b5b4e89025877ed1df77891e1bb83dd"
    sha256 arm64_big_sur:  "fed536f05c03d490065a364fe668c71489c4fc753ee35804d19cda8ae3525858"
    sha256 sonoma:         "9fcafdb6ca4303831b21dbdc280a570a200b516f8700c1a155a65474d6b87959"
    sha256 ventura:        "966e6518c3d8498f8dcd81dea1f222e8523d62e190bc03623dcb1f324f76d8c8"
    sha256 monterey:       "ad40b3627528774c084c50eadf188b05a04d740a6929fffc40c676b1ff2af999"
    sha256 big_sur:        "60c577681bfe63d97f69d75f04d9341b4befddcfaf277bd315f75ea2bb3dd09b"
    sha256 x86_64_linux:   "cc090594183be3291b7ef4a212880aa995ebeab64282d553478a9c11bd902a28"
  end

  depends_on "texinfo" => :build # Apple's is too old
  depends_on "bdw-gc"
  depends_on "gmp"
  uses_from_macos "libffi", since: :catalina

  def install
    ENV.deparallelize

    libffi_prefix = if OS.mac? && MacOS.version >= :catalina
      MacOS.sdk_path
    else
      Formula["libffi"].opt_prefix
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-libffi-prefix=#{libffi_prefix}",
                          "--with-libgc-prefix=#{Formula["bdw-gc"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"simple.cl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
