class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2022.82.tar.bz2"
  sha256 "3a038d2bbc02bf28bbdd20c012091f741a3ec5cbe460691811d714876aad75d1"
  license "MIT"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bc09368b9c67d9ad8a2836357f5d11ccc7f05e6d8de952c1dffc96dbd60deb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bc0edcd4401f0fe4b5434c747d571b22f6a6565199573cb0e452e2866b57218"
    sha256 cellar: :any_skip_relocation, monterey:       "8987521c3eb19a4c0118994ef58a99119889117c9034a218a91feaf5b724b07f"
    sha256 cellar: :any_skip_relocation, big_sur:        "33bb0e7178d106b25b33488c53cc9cbc9bd3b1c77db7c1d109bf0b13db27403e"
    sha256 cellar: :any_skip_relocation, catalina:       "9e7555bf7f8596b7524050e87beaad1f2037314a8a3ff2520170b7737071f876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c6621499402388271d7d197e3c74c3d8ceac5c6069df55898bd84d94777bde8"
  end

  head do
    url "https://github.com/mkj/dropbear.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "libxcrypt"

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
