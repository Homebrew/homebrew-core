class Make < Formula
  desc "Utility for directing compilation"
  homepage "https://www.gnu.org/software/make/"
  url "https://ftpmirror.gnu.org/make/make-4.2.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2"
  sha256 "d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589"

  bottle do
    sha256 "0f0c4fa8340fa5b5269deed987867a647bceecb17d6687276c035dad4753ca8b" => :el_capitan
    sha256 "8839228946c326de73eec5c256493e00d5130eecffac609c8aa9783f0e103304" => :yosemite
    sha256 "e36e0bbdd7f750ffdf8726e91a112a8e1145cdf91a6f9fb73cfe0ac1278aea33" => :mavericks
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  depends_on "guile" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--with-guile" if build.with? "guile"
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
