class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-20.4.24.tgz"
  sha256 "670838edf258a936b522fdb620da336de7e575aa0d27e34841727252726d0f07"
  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha256 "2a33f32a5ae0e6f53cc341e2235525a5c5bdeaf1a696e19f1fdaf2b8c36bb02c" => :catalina
    sha256 "1cccfc0bb6405dc4c9515936ee14589837794b61738477bd72ba77d5e0fcc9e9" => :mojave
    sha256 "8b216d4e8eb3491593160a2d291beb13b228bc8442cc0c5d391c196754f8968c" => :high_sierra
  end

  depends_on "texinfo" => :build # Apple's is too old
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libffi"

  def install
    ENV.deparallelize
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
