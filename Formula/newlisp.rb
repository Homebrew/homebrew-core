class Newlisp < Formula
  desc "Lisp-like, general-purpose scripting language"
  homepage "http://www.newlisp.org/"
  url "http://www.newlisp.org/downloads/newlisp-10.7.1.tgz"
  sha256 "2e300c8bed365a564d284bf3ad6c49e036256e7fc3f469ebda0b45e6e196a7cc"
  revision 1

  bottle do
    sha256 "2b05f3886282f344830370be7e8e127850c058779e17c3cf932df9f31437c716" => :mojave
    sha256 "c8b7b1204c175e91cf29f9783fab02e70692de90007cc5a393cfe0345b9d669f" => :high_sierra
    sha256 "d3d16b3e31f7c47b467a94dc502385b38d4f137afce726a996576c685c557231" => :sierra
    sha256 "8ec256c413e06d36004f36658abb28e9c71528b46496e46cfc65aab247df58ed" => :el_capitan
    sha256 "4993d9b9cb6b081d9b0790fbd9095af3f68f82afbaccc09d187399585bebd1b5" => :yosemite
  end

  depends_on "readline"

  def install
    # Required to use our configuration
    ENV.append_to_cflags "-DNEWCONFIG -c"

    # fix the prefix in a source file
    inreplace "guiserver/newlisp-edit.lsp" do |s|
      s.gsub! "#!/usr/local/bin/newlisp", "#!/usr/bin/env newlisp"
      s.gsub! "/usr/local/bin/newlisp", "#{opt_bin}/newlisp"
    end

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
