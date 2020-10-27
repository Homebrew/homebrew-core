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
    sha256 "6ad6adcfbf936f51525175d28e70eb4a6f887b92fb58e3d3cfb2930f43626d9d" => :catalina
    sha256 "8c979cf6f3fb29d665bdcdf4fe27a1c58ac51e6265a9fbb2b4bf219ddd4df734" => :mojave
    sha256 "0c0314fabb0ab26bf21606789abe3355ec1a5d9856475301d8699266b1f4689e" => :high_sierra
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
