class Newlisp < Formula
  desc "Lisp-like, general-purpose scripting language"
  homepage "http://www.newlisp.org/"
  url "http://www.newlisp.org/downloads/newlisp-10.7.5.tgz"
  sha256 "dc2d0ff651c2b275bc4af3af8ba59851a6fb6e1eaddc20ae75fb60b1e90126ec"

  bottle do
    sha256 "62fd116459d24ab0db976221fb16fd83a7a7db5447298bcc7f8b0dbf9a55f91f" => :catalina
    sha256 "179146b49c20011f3da4dbdb9b66a6ed66d5dd9f15d07aeca9b8717219a62eeb" => :mojave
    sha256 "5a0d4085a0e7fc364b3165be7e92a9dfeb2f4882e1971663ac74c70348a5c4a4" => :high_sierra
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

  def caveats
    <<~EOS
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
