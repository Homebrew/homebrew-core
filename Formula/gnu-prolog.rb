class GnuProlog < Formula
  desc "Prolog compiler with constraint solving"
  homepage "http://www.gprolog.org/"
  url "http://www.gprolog.org/gprolog-1.4.5.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/g/gprolog/gprolog_1.4.5.orig.tar.gz"

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}", "--with-doc-dir=#{doc}"
      ENV.deparallelize
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.pl").write <<~EOS
      :- initialization(main).
      main :- write('Hello World!'), nl, halt.
    EOS
    system "#{bin}/gplc", "test.pl"
    assert_match /Hello World!/, shell_output("./test")
  end
end
