class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-20.4.24.tgz"
  sha256 "670838edf258a936b522fdb620da336de7e575aa0d27e34841727252726d0f07"
  head "https://gitlab.com/embeddable-common-lisp/ecl.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 "23de8394468aa1682fdfaa00544b0316798eaf726b674f5003c6451dbecbb6f8" => :big_sur
    sha256 "612d10e1c4c34d9fcb5ec731e683210634f12111c30862ae890d225a604343ce" => :catalina
    sha256 "a29d90c9343ff63a28c6442caccf1161724804b0632624a531546db9ea63ce45" => :mojave
  end

  depends_on "texinfo" => :build # Apple's is too old
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libffi"

  def install
    ENV.deparallelize
    # Work around configure issues with Xcode 12
    # https://gitlab.com/embeddable-common-lisp/ecl/-/merge_requests/231
    # Remove once the commit is released
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system"
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
