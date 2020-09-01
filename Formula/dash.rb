class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.11.2.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/dash-0.5.11.2.tar.gz"
  sha256 "00fb7d68b7599cc41ab151051c06c01e9500540183d8aa72116cb9c742bd6d5f"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "17db29bb810402ff59bcd6d0f2ef1075b5d2d40e3ecf5667922c366d82797163" => :catalina
    sha256 "166f69be4147a52713aaf636d1a90057bc0e4ef7764c478dfdf062ae249f8d70" => :mojave
    sha256 "b8b2b9636d2cbc920180dae89e32b37b48cf915ef53136cc0be8d7d8b5764a38" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--with-libedit",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dash", "-c", "echo Hello!"
  end
end
