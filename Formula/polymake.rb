class Polymake < Formula
  desc "Tool for computations in algorithmic discrete geometry"
  homepage "https://polymake.org"
  url "https://polymake.org/lib/exe/fetch.php/download/polymake-3.2r3.tar.bz2"
  version "3.2"
  sha256 "8423dac8938dcd96e15b1195432f6a9844e8c34727c829395755a5067ce43440"

  depends_on "ant"
  depends_on "boost"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ninja"
  depends_on "ppl"
  depends_on "readline"
  depends_on "singular" => :recommended

  resource "Term::Readline::Gnu" do
    url "http://search.cpan.org/CPAN/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.35.tar.gz"
    sha256 "575d32d4ab67cd656f314e8d0ee3d45d2491078f3b2421e520c4273e92eb9125"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", prefix/"perl5/lib/perl5"
    ENV.prepend_path "PERL5LIB", prefix/"perl5/lib/perl5/darwin-thread-multi-2level"

    resource("Term::Readline::Gnu").stage do
      ENV.refurbish_args
      system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}/perl5",
                     "--includedir=#{Formula["readline"].opt_include}",
                     "--libdir=#{Formula["readline"].opt_lib}"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--without-jreality"

    system "ninja", "-C", "build/Opt", "-l2", "install"
    bin.env_script_all_files(prefix/"perl5/bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    assert_match "1 23 23 1", shell_output("#{bin}/polymake 'print cube(3)->H_STAR_VECTOR'")
    stdout, stderr, = Open3.capture3("#{bin}/polymake 'my $a=new Array<SparseMatrix<Float>>'")
    assert_match "", stderr
    assert_match "", stdout
    recompiling_info = /^polymake:  WARNING: Recompiling in .* please be patient\.\.\.$/
    _, stderr, = Open3.capture3("#{bin}/polymake 'my $a=new Array<SparseMatrix<Float>>'")
    assert_match recompiling_info, stderr
  end
end
