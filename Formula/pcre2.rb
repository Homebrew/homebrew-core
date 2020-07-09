class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://ftp.pcre.org/pub/pcre/pcre2-10.35.tar.bz2"
  sha256 "9ccba8e02b0ce78046cdfb52e5c177f0f445e421059e43becca4359c669d4613"
  head "svn://vcs.exim.org/pcre2/code/trunk"

  bottle do
    cellar :any
    sha256 "6a1e59a5db23d684f92d2bf695601d1b466f3e9d5407f704ba4679d885d13cef" => :catalina
    sha256 "d7be9b0193654484e40bc30dd330711cc1e72fa9bf29f854dd50458f6a827d1b" => :mojave
    sha256 "69c4fb400d19d1910df33376974b274362ed715ab7d67ee480b5211156174784" => :high_sierra
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  if Hardware::CPU.arch == :arm64
    patch do
      # Remove when upstream fix is released
      # https://bugs.exim.org/show_bug.cgi?id=2618
      url "https://bugs.exim.org/attachment.cgi?id=1324"
      sha256 "5e710997b822a14e0e71129e6d1232f91efb0f4d2a0aca15e1e09a31ba4c8ff2"
    end
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-pcre2-16
      --enable-pcre2-32
      --enable-pcre2grep-libz
      --enable-pcre2grep-libbz2
      --enable-jit
    ]
    args << "--enable-jit-sealloc" if Hardware::CPU.arch == :arm64

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
