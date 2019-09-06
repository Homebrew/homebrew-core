class MitScheme < Formula
  desc "MIT/GNU Scheme development tools and runtime library"
  homepage "https://www.gnu.org/software/mit-scheme/"
  url "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/9.2/mit-scheme-c-9.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/mit-scheme/stable.pkg/9.2/mit-scheme-c-9.2.tar.gz"
  sha256 "4f6a16f9c7d4b4b7bb3aa53ef523cad39b54ae1eaa3ab3205930b6a87759b170"
  revision 2

  bottle do
    sha256 "fdfd6d6c6565b5f5f34a50203ee9c661e2126eb23d181b228ef1caf32591d43a" => :mojave
    sha256 "272a286e40ee02cf625f41f25ba020b87ec07a2da277d1e8b6ca083266595aee" => :high_sierra
  end

  # Has a hardcoded compile check for /Applications/Xcode.app
  # Dies on "configure: error: SIZEOF_CHAR is not 1" without Xcode.
  # https://github.com/Homebrew/homebrew-x11/issues/103#issuecomment-125014423
  depends_on :xcode => :build
  depends_on "openssl@1.1"

  def install
    # Setting -march=native, which is what --build-from-source does, can fail
    # with the error "the object ..., passed as the second argument to apply, is
    # not the correct type." Only Haswell and above appear to be impacted.
    # Reported 23rd Apr 2016: https://savannah.gnu.org/bugs/index.php?47767
    # Note that `unless build.bottle?` avoids overriding --bottle-arch=[...].
    ENV["HOMEBREW_OPTFLAGS"] = "-march=#{Hardware.oldest_cpu}" unless build.bottle?

    # The build breaks __HORRIBLY__ with parallel make -- one target will
    # erase something before another target gets it, so it's easier to change
    # the environment than to change_make_var, because there are Makefiles
    # littered everywhere
    ENV.deparallelize

    # Liarc builds must launch within the src dir, not using the top-level
    # Makefile
    cd "src"

    # Take care of some hard-coded paths
    %w[
      6001/edextra.scm
      6001/floppy.scm
      compiler/etc/disload.scm
      edwin/techinfo.scm
      edwin/unix.scm
      swat/c/tk3.2-custom/Makefile
      swat/c/tk3.2-custom/tcl/Makefile
      swat/scheme/other/btest.scm
    ].each do |f|
      inreplace f, "/usr/local", prefix
    end

    inreplace "microcode/configure" do |s|
      s.gsub! "/usr/local", prefix
      # Fixes "configure: error: No MacOSX SDK for version: 10.10"
      # Reported 23rd Apr 2016: https://savannah.gnu.org/bugs/index.php?47769
      s.gsub! /SDK=MacOSX\${MACOSX}$/, "SDK=MacOSX#{MacOS.sdk.version}"
    end

    inreplace "etc/make-liarc.sh" do |s|
      # Allows us to build without X11
      # https://savannah.gnu.org/bugs/?47887
      s.gsub! "run_configure", "run_configure --without-x"
    end

    system "etc/make-liarc.sh", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # https://www.cs.indiana.edu/pub/scheme-repository/code/num/primes.scm
    (testpath/"primes.scm").write <<~EOS
      ;
      ; primes
      ; By Ozan Yigit
      ;
      (define  (interval-list m n)
        (if (> m n)
            '()
            (cons m (interval-list (+ 1 m) n))))

      (define (sieve l)
        (define (remove-multiples n l)
          (if (null? l)
        '()
        (if  (= (modulo (car l) n) 0)      ; division test
             (remove-multiples n (cdr l))
             (cons (car l)
             (remove-multiples n (cdr l))))))

        (if (null? l)
            '()
            (cons (car l)
            (sieve (remove-multiples (car l) (cdr l))))))

      (define (primes<= n)
        (sieve (interval-list 2 n)))

      ; (primes<= 300)
    EOS

    output = shell_output(
      "#{bin}/mit-scheme --load primes.scm --eval '(primes<= 72)' < /dev/null",
    )
    assert_match(
      /;Value 2: \(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71\)/,
      output,
    )
  end
end
