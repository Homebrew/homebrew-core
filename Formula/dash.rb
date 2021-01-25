class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.11.3.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/dash-0.5.11.3.tar.gz"
  sha256 "62b9f1676ba6a7e8eaec541a39ea037b325253240d1f378c72360baa1cbcbc2a"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e8e05221792dc3acb2cdc5e394162872882656d381effca6a6be91a0afa79eb2" => :big_sur
    sha256 "3621cea063b99b70a27bd515a39c87b55d4f036293c74de5b56912b7294bd543" => :catalina
    sha256 "2084534c9a3fe3bfae86eaf4a01dca8eff1ad9645bb63f8ee422f327fa1b7b7b" => :mojave
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
