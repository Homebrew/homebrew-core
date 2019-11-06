class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://ftp.pcre.org/pub/pcre/pcre2-10.33.tar.bz2"
  sha256 "35514dff0ccdf02b55bd2e9fa586a1b9d01f62332c3356e379eabb75f789d8aa"
  head "svn://vcs.exim.org/pcre2/code/trunk"

  bottle do
    cellar :any
    sha256 "7b92993a7ad0487cabc4395e3633d8294896fa9ffa9e46507d9a7ef25a213ab8" => :catalina
    sha256 "fb30c3eebba4483a10378bc8df52f96761fed4a1ac5572ad1bf4afbf2f8638c5" => :mojave
    sha256 "26b34cf7a846d49cdbdefa853227d7d4b02d6bd97c59dacdb0fb9dcf155444b5" => :high_sierra
    sha256 "a712fa6195fd968bae380e54709f46f66a94c69549a77f0836dae43ed95e11dc" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-pcre2-16",
                          "--enable-pcre2-32",
                          "--enable-pcre2grep-libz",
                          "--enable-pcre2grep-libbz2",
                          "--enable-jit"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
