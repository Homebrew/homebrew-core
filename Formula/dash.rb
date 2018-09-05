class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.10.2.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/dash-0.5.10.2.tar.gz"
  sha256 "3c663919dc5c66ec991da14c7cf7e0be8ad00f3db73986a987c118862b5f6071"

  bottle do
    cellar :any_skip_relocation
    sha256 "08b5b8cb7c8ba7946a800dc477faede8d13fe877af4305b11d91ea9e5afba4cb" => :mojave
    sha256 "11463b8d52c2d9616c2deaf40a4a4a186baf6c2b4724c3c8b35efc527f6ad0ef" => :high_sierra
    sha256 "ab44bf2512098fca3db4d0655191c1deaa0d0d8311d531976603242b1c7136e4" => :sierra
    sha256 "c634e0bb97fc544fc425c62d429e239519d7ecf447df4debc6406792ba1eb476" => :el_capitan
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
