class Newlisp < Formula
  desc "Lisp-like, general-purpose scripting language"
  homepage "http://www.newlisp.org/"
  url "http://www.newlisp.org/downloads/newlisp-10.7.1.tgz"
  sha256 "2e300c8bed365a564d284bf3ad6c49e036256e7fc3f469ebda0b45e6e196a7cc"
  revision 1

  bottle do
    sha256 "7b9a804b9fdb3836b57cc58dd42208e18697fd7ce6b0b9dfcc7dcb1c3deca4d1" => :mojave
    sha256 "59d93234b8ba1351198d2507b83e4aed14520d0b8b04bb8710e4f52e53f7b128" => :high_sierra
    sha256 "c7a87aae1ccad6074557bd9fa227295517e176236bdcedb8f29ade5c36e62bba" => :sierra
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
