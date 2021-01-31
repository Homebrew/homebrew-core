class MitScheme < Formula
  desc "MIT/GNU Scheme development tools and runtime library"
  homepage "https://www.gnu.org/software/mit-scheme/"
  url "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/11.1/mit-scheme-11.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/mit-scheme/stable.pkg/11.1/mit-scheme-11.1.tar.gz"
  sha256 "76c4f2eb61b5c4b4c2fe5159484a8d4a24e469fae14c0dd4c9df6221016856a6"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/?C=M&O=D"
    strategy :page_match
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 "ae2167a7a177e9731350e5f7d91679dc29856fd1b504653c5e54c5e3d2266393" => :big_sur
    sha256 "5ae123ef4a76b34e2b927873991a823b0ab68a5518d1543f1e76bf9d3c36e589" => :catalina
    sha256 "7f74120df838cc2f4542c73f20b7f3e3473f23a775d249e2b8170e6acfd43ed1" => :mojave
    sha256 "cf0d2bf18da0dd0454f53f125bcb4d85632619cd8a79f3dd30ddb16a19c0d470" => :high_sierra
  end

  # Has a hardcoded compile check for /Applications/Xcode.app
  # Dies on "configure: error: SIZEOF_CHAR is not 1" without Xcode.
  # https://github.com/Homebrew/homebrew-x11/issues/103#issuecomment-125014423
  depends_on xcode: :build
  depends_on "openssl@1.1"

  resource "bootstrap" do
    url "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/11.1/mit-scheme-11.1-x86-64.tar.gz"
    sha256 "92bcb77788d982a6522119ea0a51935b680b9ada88f99c21bcb9d843d6b384cd"
  end

  def install
    # Setting -march=native, which is what --build-from-source does, can fail
    # with the error "the object ..., passed as the second argument to apply, is
    # not the correct type." Only Haswell and above appear to be impacted.
    # Reported 23rd Apr 2016: https://savannah.gnu.org/bugs/index.php?47767
    # NOTE: `unless build.bottle?` avoids overriding --bottle-arch=[...].
    ENV["HOMEBREW_OPTFLAGS"] = "-march=#{Hardware.oldest_cpu}" unless build.bottle?

    resource("bootstrap").stage do
      cd "src"
      system "./configure", "--prefix=#{buildpath}/staging", "--without-x"
      system "make"
      system "make", "install"
    end

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

    ENV.prepend_path "PATH", buildpath/"staging/bin"

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
