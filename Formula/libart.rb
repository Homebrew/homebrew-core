class Libart < Formula
  desc "Library for high-performance 2D graphics"
  homepage "https://people.gnome.org/~mathieu/libart/libart.html"
  url "https://download.gnome.org/sources/libart_lgpl/2.3/libart_lgpl-2.3.21.tar.bz2"
  sha256 "fdc11e74c10fc9ffe4188537e2b370c0abacca7d89021d4d303afdf7fd7476fa"
  license "LGPL-2.0-or-later"

  # We use a common regex because libart doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libart_lgpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6264e9bdd039ee87e34893b8565f776309f21d9e0730a1cf48fa801453369cd5"
    sha256 cellar: :any,                 arm64_monterey: "5dc4edf96205d8064d34eca369566f41be1b0df69c4a598bece713550e5aeb26"
    sha256 cellar: :any,                 arm64_big_sur:  "8daf6e0691d2fc7f919716cb760a80bbba53295aa5c92d8b05aef4aa1172b09b"
    sha256 cellar: :any,                 ventura:        "9547ae5b20144048c3c37a7486a06cc50e6b4d6b4924c2a15fda580765b2abb3"
    sha256 cellar: :any,                 monterey:       "0d0cecb8fccc2fc80a1268bda9c863dae95b45c1cacd73da5e8182d513d41241"
    sha256 cellar: :any,                 big_sur:        "1204889805658d4aeb3ec37251e8ab064e995654008be97588bc034505b77314"
    sha256 cellar: :any,                 catalina:       "54ca46ebc37bba1fdc39e8b28c166202e7d488d93cc5b4acfb042a14adec84f9"
    sha256 cellar: :any,                 mojave:         "5fc8b240a975efcb5bd3992afd4d01c0a393a306a4a66192cb9a10e580bcf4d3"
    sha256 cellar: :any,                 high_sierra:    "c5ae59f4955fd1b4e3c49976b06609d56c5079d2b0f6e0675b356b1eb09181cd"
    sha256 cellar: :any,                 sierra:         "e9e14623ba0284a89dd09c7be72393619582c5d0489891cd1f654b6c26b0fabc"
    sha256 cellar: :any,                 el_capitan:     "18fb7a842650151fef102efadefa52aa12dc3f597ace95b8e25efe6518a65d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b28ae4a3601b0bace6e40c19e616e2e321f17231a378241dae4aa9db9764d75"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
