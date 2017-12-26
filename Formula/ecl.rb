class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-16.1.3.tgz"
  sha256 "76a585c616e8fa83a6b7209325a309da5bc0ca68e0658f396f49955638111254"
  revision 2

  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha256 "cbc9e5cc823e969e9de13fcd93a9044d326964f64512055d1815d7adb85cec81" => :high_sierra
    sha256 "bd2c5fc4ca15b1e71156a3183bf2cf49c326b994c8f9f81b0f94fd9eb0960005" => :sierra
    sha256 "6f99f513efcf23a4b1e71b2c8e188e8f41fe976cccf2da855aa1285c35924131" => :el_capitan
    sha256 "75ee54632fbb5d6b81787e483d847162194eeb8bbe60059fea87f8bdda9c8e8c" => :yosemite
  end

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
