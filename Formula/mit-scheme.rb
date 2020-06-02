class MitScheme < Formula
  desc "MIT/GNU Scheme development tools and runtime library"
  homepage "https://www.gnu.org/software/mit-scheme/"
  url "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/10.1.10/mit-scheme-10.1.10-svm1.tar.gz"
  mirror "https://ftpmirror.gnu.org/mit-scheme/stable.pkg/10.1.10/mit-scheme-10.1.10-svm1.tar.gz"
  version "10.1.10"
  sha256 "36ad0aba50d60309c21e7f061c46c1aad1dda0ad73d2bb396684e49a268904e4"

  bottle do
    sha256 "aeec8e0d463f173b7e1bf1aa5840d7d119559379c9c4024f72ccbcc18649ee40" => :catalina
    sha256 "c8815c908efaeeb60ae5591c39432b82dd54193fc823ef2c1da3c4dcb0a7c16c" => :mojave
    sha256 "81ed1c679028078098b3b77a37886660e97748a75e153f498d7038e4b2600fcc" => :high_sierra
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
    ].each do |f|
      inreplace f, "/usr/local", prefix
    end

    inreplace "microcode/configure" do |s|
      s.gsub! "/usr/local", prefix
      # Fixes "configure: error: No MacOSX SDK for version: 10.10"
      # Reported 23rd Apr 2016: https://savannah.gnu.org/bugs/index.php?47769
      s.gsub! /SDK=MacOSX\$\{MACOS\}$/, "SDK=MacOSX#{MacOS.sdk.version}"
    end

    inreplace "edwin/compile.sh" do |s|
      s.gsub! "mit-scheme", "#{bin}/mit-scheme"
    end

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--without-x"
    system "make"
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
      /;Value: \(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71\)/,
      output,
    )
  end
end
