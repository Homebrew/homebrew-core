class MitScheme < Formula
  desc "MIT/GNU Scheme development tools and runtime library"
  homepage "https://www.gnu.org/software/mit-scheme/"
  url "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/12.1/mit-scheme-12.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/mit-scheme/stable.pkg/12.1/mit-scheme-12.1.tar.gz"
  sha256 "5509fb69482f671257ab4c62e63b366a918e9e04734feb9f5ac588aa19709bc6"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/?C=M&O=D"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 monterey:     "bae1d2a271efb27c40b785490cb77ae62a2ad2856c49169df4ca4b6fa5d15a77"
    sha256 big_sur:      "e53230ae27dc40a7b3a4ed54dfe9e905b60a605f5693e5fdbea513f4a5f12b35"
    sha256 x86_64_linux: "84fc2e7429a15a8a894e39b4edfe042e4ddc404ef517896bcf63c8ee0c97bbed"
  end

  # Has a hardcoded compile check for /Applications/Xcode.app
  # Dies on "configure: error: SIZEOF_CHAR is not 1" without Xcode.
  # https://github.com/Homebrew/homebrew-x11/issues/103#issuecomment-125014423
  depends_on xcode: :build

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  on_macos do
    depends_on arch: :x86_64 # No support for Apple silicon: https://www.gnu.org/software/mit-scheme/#status
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  resource "bootstrap" do
    on_arm do
      url "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/12.1/mit-scheme-12.1-aarch64le.tar.gz"
      sha256 "708ffec51843adbc77873fc18dd3bafc4bd94c96a8ad5be3010ff591d84a2a8b"
    end

    on_intel do
      url "https://ftp.gnu.org/gnu/mit-scheme/stable.pkg/12.1/mit-scheme-12.1-x86-64.tar.gz"
      sha256 "8cfbb21b0e753ab8874084522e4acfec7cadf83e516098e4ab788368b748ae0c"
    end
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
      s.gsub!(/SDK=MacOSX\$\{MACOS\}$/, "SDK=MacOSX#{MacOS.sdk.version}") if OS.mac?
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
