class Polymake < Formula
  desc "Tool for computations in algorithmic discrete geometry"
  homepage "https://polymake.org"
  url "https://polymake.org/lib/exe/fetch.php/download/polymake-3.2r3.tar.bz2"
  sha256 "8423dac8938dcd96e15b1195432f6a9844e8c34727c829395755a5067ce43440"

  depends_on "boost"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ninja"
  depends_on "ppl"
  depends_on "readline"
  depends_on "singular"

  resource "Term::Readline::Gnu" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAYASHI/Term-ReadLine-Gnu-1.35.tar.gz"
    sha256 "575d32d4ab67cd656f314e8d0ee3d45d2491078f3b2421e520c4273e92eb9125"
  end

  def install
    # Fix file not found errors for /usr/lib/system/libsystem_symptoms.dylib and
    # /usr/lib/system/libsystem_darwin.dylib on 10.11 and 10.12, respectively
    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    ENV.prepend_create_path "PERL5LIB", libexec/"perl5/lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"perl5/lib/perl5/darwin-thread-multi-2level"

    resource("Term::Readline::Gnu").stage do
      # Prevent the Makefile to try and build universal binaries
      ENV.refurbish_args
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}/perl5",
                     "--includedir=#{Formula["readline"].opt_include}",
                     "--libdir=#{Formula["readline"].opt_lib}"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--without-java",
                          "--without-bliss",
                          "--without-soplex"

    system "ninja", "-C", "build/Opt", "install"
    bin.env_script_all_files(libexec/"perl5/bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    assert_match "1 23 23 1", shell_output("#{bin}/polymake 'print cube(3)->H_STAR_VECTOR'")
    stdout, stderr, = Open3.capture3("#{bin}/polymake 'my $a=new Array<SparseMatrix<Float>>'")
    assert_predicate stderr, :empty?
    assert_predicate stdout, :empty?
    recompiling_info = /^polymake:  WARNING: Recompiling in .* please be patient\.\.\.$/
    _, stderr, = Open3.capture3("#{bin}/polymake 'my $a=new Array<SparseMatrix<Float>>'")
    assert_match recompiling_info, stderr
  end
end
