class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.10.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/dash-0.5.10.tar.gz"
  sha256 "ad70e0cc3116b424931c392912b3ebdb8053b21f3fd968c782f0b19fd8ae31ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f1902af5e7e0e39575260af6b9058a48afc45557ae5bbd0e99b4e093ab07f4a" => :high_sierra
    sha256 "3624150f7a9ddcf1d47266aa9623c16931c4957d2fbcd1061317c27117dd6b1d" => :sierra
    sha256 "40ba355540342b25cc61fd28940829bc5ac819ac390c96b4f20340f4d084fd8b" => :el_capitan
  end

  head do
    url "https://git.kernel.org/pub/scm/utils/dash/dash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--with-libedit",
                          "--disable-dependency-tracking",
                          "--enable-fnmatch",
                          "--enable-glob"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dash", "-c", "echo Hello!"
  end
end
