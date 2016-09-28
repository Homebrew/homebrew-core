class Newlisp < Formula
  desc "Lisp-like, general-purpose scripting language"
  homepage "http://www.newlisp.org/"
  url "http://www.newlisp.org/downloads/newlisp-10.7.0.tgz"
  sha256 "c4963bf32d67eef7e4957f7118632a0c40350fd0e28064bce095865b383137bb"
  revision 1

  bottle do
    sha256 "76637be4fb4ba87141134cab1dc708d53b4220aa96879b762f253544157cc2f1" => :sierra
    sha256 "59a068766a6432ef25bde0496a0d70be73af1c4c6d1ae603f56a59732b2598e2" => :el_capitan
    sha256 "360987ebd0f108b6241edb15f4acbb85efa4a80585424154068ea8567e3fad01" => :yosemite
  end

  depends_on "readline" => :recommended

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

  def caveats; <<-EOS.undent
    If you have brew in a custom prefix, the included examples
    will need to be be pointed to your newlisp executable.
    EOS
  end

  test do
    path = testpath/"test.lsp"
    path.write <<-EOS
      (println "hello")
      (exit 0)
    EOS

    assert_equal "hello\n", shell_output("#{bin}/newlisp #{path}")
  end
end
