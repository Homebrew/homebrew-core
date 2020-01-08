class GnuProlog < Formula
  desc "Prolog compiler with constraint solving"
  homepage "http://www.gprolog.org/"
  url "http://www.gprolog.org/gprolog-1.4.5.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/g/gprolog/gprolog_1.4.5.orig.tar.gz"
  sha256 "bfdcf00e051e0628b4f9af9d6638d4fde6ad793401e58a5619d1cc6105618c7c"

  bottle do
    cellar :any_skip_relocation
    sha256 "30c1693edfb527b5d9a3de534b3f47b0667303d23b451006ce9c3a923a068025" => :mojave
    sha256 "21072ba374c5426f89448664738eea6e331c0e9da452ca7945d709901b72eda4" => :high_sierra
    sha256 "957d8a1d72f338cb94765a82f88d5154bb0611e938db765de2b8120fc8e8f0db" => :sierra
    sha256 "4437bfce43e947a2ae48b50963b9cda18c257b3dbe202f49dde1da8f615d54e2" => :el_capitan
  end

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
