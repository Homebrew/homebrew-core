class GnuProlog < Formula
  desc "Prolog compiler with constraint solving"
  homepage "http://www.gprolog.org/"
  url "http://gprolog.univ-paris1.fr/gprolog-1.4.4.tar.gz"
  sha256 "18c0e9644b33afd4dd3cdf29f94c099ad820d65e0c99da5495b1ae43b4f2b18e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9a449562401a31c551224e9703ec45dcf4b013b1a77d9b5de65a0b162c744d0a" => :sierra
    sha256 "9d8e49f034bd641578443d1c422937a14f4819742ef6844dee4df1998a6388c9" => :el_capitan
    sha256 "b835e9887909affa110d4a57abf7bfecee8d9aee0fb29f38432112c1347441d2" => :yosemite
    sha256 "4412b7d3c6ee2390189fe3bd339f8c3ed028fb3a9b145794038f4c4f0f0ea90f" => :mavericks
  end

  # Upstream patch:
  # https://sourceforge.net/p/gprolog/code/ci/784b3443a0a2f087c1d1e7976739fa517efe6af6
  patch do
    url "https://gist.githubusercontent.com/jacknagel/7549696/raw/3078eef282ca141c95a0bf74396f4248bbe34775/gprolog-clang.patch"
    sha256 "3b47551d96f23ab697f37a68ab206219ee29f747bc46b9f0cae9b60c5dafa3b2"
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
    (testpath/"test.pl").write <<-EOS.undent
      :- initialization(main).
      main :- write('Hello World!'), nl, halt.
    EOS
    system "#{bin}/gplc", "test.pl"
    assert_match /Hello World!/, shell_output("./test")
  end
end
