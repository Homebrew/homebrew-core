class Loris < Formula
  desc "Audio analysis, manipulation and synthesis"
  homepage "http://www.cerlsoundgroup.org/Loris"
  url "https://downloads.sourceforge.net/code-snapshots/git/l/lo/loris/loris-code.git/loris-loris-code-27d14aef9e50573bccb3e11d9c6b5c051ea04862.zip"
  version "1.9.0"
  sha256 "916d37d805ac07d823a351fb9742b107f306cafcaf4242a685bac3f0406077f0"

  depends_on "fftw"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./reconf"
    system "./configure", "--prefix=#{prefix}", "--with-python=no"
    system "make", "install"
  end

  test do
    simple_test = pipe_output("#{bin}/loris-analyze 50 -o /dev/null -verbose", "testing testing 1 2 3")
    return if simple_test =~ /analysis complete/
    raise "tried running\n\nloris-analyze 50 -o /dev/null
-verbose | echo 'testing 1 2 3'\n\n\
expected '[..]analysis complete[..]' but got:\n\n\
#{simple_test}"
  end
end
