class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.11.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/dash-0.5.11.tar.gz"
  sha256 "4dd9a6ed5fe7546095157918fe5d784bb0b7887ae13de50e1e2d11e1b5a391cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "21446fdece550bbaa24c64db4f03cba0c41a6b46eaaa20101573026a7f57f96c" => :catalina
    sha256 "aa6941a564fca697da6eb30e3691a8fa354de093d05ee84bbbc50c8045a55f66" => :mojave
    sha256 "49ebe51a7662187224ab620aa50b0473b11c1f88372f7c17da328559d895f5e0" => :high_sierra
    sha256 "4c7ca79c9b006065cb9bba57190103c518791b5a7ea078bb1f960e6f6c9dd7e9" => :sierra
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
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dash", "-c", "echo Hello!"
  end
end
