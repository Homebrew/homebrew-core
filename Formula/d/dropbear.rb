class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2024.85.tar.bz2"
  sha256 "86b036c433a69d89ce51ebae335d65c47738ccf90d13e5eb0fea832e556da502"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b065409784d08f2f399e6825aeec939262bdf0f83b55de7b0116dec210215c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ccc4def7f687eefdf87d3a858be0b7a816f1125d0f65177c00e1ac2e089934d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e9de7a77f87fe18ce1854b4fe9f44222ae44c8def0b5f0a4b5121e95a20809f"
    sha256 cellar: :any_skip_relocation, sonoma:         "17249ee6fac027c1d89c516ca5df610788517670677c080bb2544ed837048f28"
    sha256 cellar: :any_skip_relocation, ventura:        "724b8f22390efad2c3c37cf8fcb6b8955426fdd947c1133385d5cc9256f29baf"
    sha256 cellar: :any_skip_relocation, monterey:       "4b9dba9e11a11b3cc9a26c6ef8e388c6e98b350ef1643204932ff2e20aab718c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "415ec7081d0c72c66973224e1a8c49f0917b329a2ab54730162600fac88446ae"
  end

  head do
    url "https://github.com/mkj/dropbear.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    ENV.deparallelize

    if build.head?
      system "autoconf"
      system "autoheader"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-pam",
                          "--enable-zlib",
                          "--enable-bundled-libtom",
                          "--sysconfdir=#{etc}/dropbear"
    system "make"
    system "make", "install"
  end

  test do
    testfile = testpath/"testec521"
    system "#{bin}/dbclient", "-h"
    system "#{bin}/dropbearkey", "-t", "ecdsa", "-f", testfile, "-s", "521"
    assert_predicate testfile, :exist?
  end
end
