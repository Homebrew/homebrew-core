class GnuProlog < Formula
  desc "Prolog compiler with constraint solving"
  homepage "http://www.gprolog.org/"
  url "http://gprolog.univ-paris1.fr/gprolog-1.4.5.tar.gz"
  sha256 "bfdcf00e051e0628b4f9af9d6638d4fde6ad793401e58a5619d1cc6105618c7c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f8d446ec6be0b8db9d4a2b6602877386a050f678d7900e5b8b00f345a4562f5c" => :high_sierra
    sha256 "9a449562401a31c551224e9703ec45dcf4b013b1a77d9b5de65a0b162c744d0a" => :sierra
    sha256 "9d8e49f034bd641578443d1c422937a14f4819742ef6844dee4df1998a6388c9" => :el_capitan
    sha256 "b835e9887909affa110d4a57abf7bfecee8d9aee0fb29f38432112c1347441d2" => :yosemite
    sha256 "4412b7d3c6ee2390189fe3bd339f8c3ed028fb3a9b145794038f4c4f0f0ea90f" => :mavericks
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
