class CmuPocketsphinx < Formula
  desc "Lightweight speech recognition engine for mobile devices"
  homepage "http://cmusphinx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cmusphinx/pocketsphinx/0.8/pocketsphinx-0.8.tar.gz"
  sha256 "874c4c083d91c8ff26a2aec250b689e537912ff728923c141c4dac48662cce7a"

  bottle do
    sha256 "12abc8b527906e7ed0d2f6f0a6b6cb5c00f548fe94fcce995bdc80f43b4cf17b" => :sierra
    sha256 "2f1f4738dbcf7641a530b82c4dc6447ecadb5f9b60cd2484c33c379efb5c46e5" => :el_capitan
    sha256 "dea4e6a8e131f68c94a6b9fb783a0445476354a90629001d5007fe3b4e5247bd" => :yosemite
    sha256 "9d49cd11915d906db23021eeaed8bed1ee5e565eaad03a1a96cbb03448ae6867" => :mavericks
  end

  head do
    url "https://github.com/cmusphinx/pocketsphinx.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "swig" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cmu-sphinxbase"

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
