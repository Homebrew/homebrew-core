class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2022.82.tar.bz2"
  sha256 "3a038d2bbc02bf28bbdd20c012091f741a3ec5cbe460691811d714876aad75d1"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aa3eb25000550815f3538bd8e43119d040e72ef5b8153ba65f7734c46f5817c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "874b0b702a08ed53d0c047e227b63a0c9f19e5f3e05c6ecea9b1c06020e49f38"
    sha256 cellar: :any_skip_relocation, monterey:       "e433cf6cd9d31f3212057b1dfdc179e0e4afb9387ea4da0f88063cd32b5adcb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c772c987dddbf9376d497d25f453cf5e9e583e4b192836a30b89d07bee3ade6"
    sha256 cellar: :any_skip_relocation, catalina:       "763bc9e50c22d55f5a0cf94e3cfb6b27f78360747bb47e4adeb2b608ef56651a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ea56ead9adcc4aafa405fcf25af3c2e6ab00252df3f140bbc0723d366ea4ffd"
  end

  head do
    url "https://github.com/mkj/dropbear.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

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
