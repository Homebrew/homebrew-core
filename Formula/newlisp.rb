class Newlisp < Formula
  desc "Lisp-like, general-purpose scripting language"
  homepage "http://www.newlisp.org/"
  url "http://www.newlisp.org/downloads/newlisp-10.7.5.tgz"
  sha256 "dc2d0ff651c2b275bc4af3af8ba59851a6fb6e1eaddc20ae75fb60b1e90126ec"

  bottle do
    sha256 "7b9a804b9fdb3836b57cc58dd42208e18697fd7ce6b0b9dfcc7dcb1c3deca4d1" => :mojave
    sha256 "59d93234b8ba1351198d2507b83e4aed14520d0b8b04bb8710e4f52e53f7b128" => :high_sierra
    sha256 "c7a87aae1ccad6074557bd9fa227295517e176236bdcedb8f29ade5c36e62bba" => :sierra
  end

  depends_on "readline"

  def install
    # Required to use our configuration
    ENV.append_to_cflags "-DNEWCONFIG -c"

    system "./configure-alt", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def caveats; <<~EOS
    If you have brew in a custom prefix, the included examples
    will need to be be pointed to your newlisp executable.
  EOS
  end

  test do
    path = testpath/"test.lsp"
    path.write <<~EOS
      (println "hello")
      (exit 0)
    EOS

    assert_equal "hello\n", shell_output("#{bin}/newlisp #{path}")
  end
end
