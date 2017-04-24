class Make < Formula
  desc "Utility for directing compilation"
  homepage "https://www.gnu.org/software/make/"
  url "https://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/make/make-4.2.1.tar.bz2"
  sha256 "d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589"

  bottle do
    sha256 "d6a0f2bfd83a8299b6a7dfa4aa936ffcd03603da10c26cccad06137c668df894" => :sierra
    sha256 "08fce0ecb389bc90b3acc5ea32835da463dd791682e021e8f9bac6c3fabadc3d" => :el_capitan
    sha256 "2c4367b9f688209028b611bf22f2eab38885b7eaea91561a19d963ad72e4313e" => :yosemite
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  deprecated_option "with-guile" => "with-guile@2.0"

  depends_on "guile@2.0" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--with-guile" if build.with? "guile@2.0"
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<-EOS.undent
      default:
      \t@echo Homebrew
    EOS

    cmd = build.with?("default-names") ? "make" : "gmake"

    assert_equal "Homebrew\n",
      shell_output("#{bin}/#{cmd}")
  end
end
