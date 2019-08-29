class MitScheme < Formula
  desc "MIT/GNU Scheme development tools and runtime library"
  homepage "https://www.gnu.org/software/mit-scheme/"
  url "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/9.2/mit-scheme-c-9.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/mit-scheme/stable.pkg/9.2/mit-scheme-c-9.2.tar.gz"
  sha256 "4f6a16f9c7d4b4b7bb3aa53ef523cad39b54ae1eaa3ab3205930b6a87759b170"
  revision 2

  bottle do
    rebuild 2
    sha256 "482da1493fa7dc5d4e1b5aebf3a53ea95cdd080066aa8a4fcab2051d5ab50d86" => :mojave
    sha256 "715a8d56b6b6b0debe6aac7e968c369555b210863da6f7514999307c9df348a8" => :high_sierra
    sha256 "6b7a6ecec12a5a856b795ce634c0ceb8e87714f9cdd272a912e312c3bc5cb9d4" => :sierra
    sha256 "23df7103a75311ba33fed035413892b73f1e724e1df5b63bd677709d29bfdb92" => :el_capitan
    sha256 "be2b340bb25c87141bae94010e4f6ec0234ac3c237e66ffbdb5ae98e2cb7462f" => :yosemite
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
