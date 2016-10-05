class CmuSphinxbase < Formula
  desc "Lightweight speech recognition engine for mobile devices"
  homepage "http://cmusphinx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cmusphinx/sphinxbase/0.8/sphinxbase-0.8.tar.gz"
  sha256 "55708944872bab1015b8ae07b379bf463764f469163a8fd114cbb16c5e486ca8"

  bottle do
    cellar :any
    sha256 "d0b78556158f96f23fc5ffed7d50cf0de8808de0cce61b681448a8775b8665d3" => :sierra
    sha256 "3f9d274b9d80b236ca2b567ce6fde2d98daf2ce61363c64b40b8d0f660835164" => :el_capitan
    sha256 "488fe47cae524867c5a6fc49e4589ae480bb1c162a3bca1442e0a51035e2637b" => :yosemite
    sha256 "b13d896f6888b96d6178980df2ef8eb0cfa4c994e38a9b7fb29cb69faca96f21" => :mavericks
  end

  head do
    url "https://github.com/cmusphinx/sphinxbase.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "swig" => :build
  end

  depends_on "pkg-config" => :build
  # If these are found, they will be linked against and there is no configure
  # switch to turn them off.
  depends_on "libsndfile"
  depends_on "libsamplerate" => "with-libsndfile"

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
