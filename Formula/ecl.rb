class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-16.1.3.tgz"
  sha256 "76a585c616e8fa83a6b7209325a309da5bc0ca68e0658f396f49955638111254"

  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha256 "777aa2584459020d3f4d42488b60a06a0857158a1ee39e14754695fd4eaec139" => :sierra
    sha256 "8915d3c5862aa5b89beb28119778715308f6639abde6fcefe052f716c3db9560" => :el_capitan
    sha256 "46647c3577257ff30197afe689161d36a8bd8e99a2b24eaa44f97f2f38e644b1" => :yosemite
    sha256 "5fa6a6a6f0ac717897ed635484a4b1675a48b8455e6178990bbce5109353131d" => :mavericks
  end

  depends_on "gmp"
  depends_on "bdw-gc"

  def install
    # These environment variables are necessary or gmp / boehmgc won't be found
    # No idea why
    gmp = Formula["gmp"]
    boehmgc = Formula["boehmgc"]
    ENV.append "CFLAGS", "-I#{gmp.opt_include} -I#{boehmgc.opt_include}"
    ENV.append "CXXFLAGS", "-I#{gmp.opt_include} -I#{boehmgc.opt_include}"
    ENV.append "LDFLAGS", "-L#{gmp.opt_lib} -L#{boehmgc.opt_lib}"

    system "./configure",
                          "--prefix=#{prefix}",
                          "--enable-threads=yes",
                          "--with-dffi=included",
                          "--with-cxx",
                          "--enable-gmp=system"
    system "make", "-j", "1"
    system "make", "install"
    # make check
    # Doesn't work but doesn't fail the build
    # FIXME
    #
    # ==> make check
    # cd build && /Applications/Xcode.app/Contents/Developer/usr/bin/make check
    # TESTS=""
    # dyld: Library not loaded: @libdir@/libecl.16.1.dylib
    #   Referenced from: /usr/local/Cellar/ecl/16.1.3//bin/ecl
    #     Reason: image not found
    system "make", "check"
  end

  test do
    (testpath/"simple.cl").write <<-EOS.undent
      (write-line (write-to-string (+ 2 2)))
    EOS
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
