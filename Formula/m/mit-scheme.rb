class MitScheme < Formula
  desc "MIT/GNU Scheme development tools and runtime library"
  homepage "https://www.gnu.org/software/mit-scheme/"
  url "https://ftpmirror.gnu.org/gnu/mit-scheme/stable.pkg/12.1/mit-scheme-12.1-svm1-64le.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/12.1/mit-scheme-12.1-svm1-64le.tar.gz"
  sha256 "2c5b5bf1f44c7c2458da79c0943e082ae37f1752c7d9d1ce0a61f7afcbf04304"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftpmirror.gnu.org/gnu/mit-scheme/stable.pkg/?C=M&O=D"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
    strategy :page_match
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "6091fa88278d223d1f892c9f9383dbf81833e007c34f6eed625720d9e9c7457d"
    sha256 arm64_sequoia:  "5b2f5cddeb07d989aeb50ed587357c3da57bc2cfbe13dd5e3cc29b754ec6dfc9"
    sha256 arm64_sonoma:   "da2acf2666e321393c150917e783456c04942de61a2b4db2eebfaeaac094168b"
    sha256 arm64_ventura:  "23923b9cbbf60f33e46325ec788edaf149b1d43b62ddd69beff33528b14453c3"
    sha256 arm64_monterey: "cfdb8ea9127c65a67e727fe75c293cde238172a18de91343540ff49c949f8449"
    sha256 sonoma:         "a8ebb5f3d8e66fd9a2924b02bdd0e920e5484890865ea107fdbba9a737dc703c"
    sha256 ventura:        "03ec5e2d199d6736dc7345d4ca3c083a78c53cb024b3874edb0e45aeb7123a2a"
    sha256 monterey:       "72fcee689c1ca44d5834d654490f8368f099e939f4065c4f9f06d24c0022bd19"
    sha256 arm64_linux:    "3c78aa4816f440ce61da51a88b8bd412e9b46758b5c069484d6d125fb10c8796"
    sha256 x86_64_linux:   "0e910ffb8aff109164099832f8d465f54e9e0c731a0580cb0c794970e3f6ce11"
  end

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
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
      microcode/configure
    ].each do |f|
      inreplace f, "/usr/local", prefix
    end

    inreplace "edwin/compile.sh", "mit-scheme", bin/"mit-scheme"

    ENV.prepend_path "PATH", buildpath/"staging/bin"

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--without-x"
    system "make"
    system "make", "install"
  end

  test do
    # https://www.cs.indiana.edu/pub/scheme-repository/code/num/primes.scm
    (testpath/"primes.scm").write <<~SCHEME
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
    SCHEME

    output = shell_output(
      "#{bin}/mit-scheme --load primes.scm --eval '(primes<= 72)' < /dev/null",
    )
    assert_match(
      /;Value: \(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71\)/,
      output,
    )
  end
end
