class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2022.83.tar.bz2"
  sha256 "bc5a121ffbc94b5171ad5ebe01be42746d50aa797c9549a4639894a16749443b"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcec1a39e5a5e4690a070e3398328890065cdd2d62b879fe0c1998f33a8a2f51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2453eaa6d3db311eb4c1fbfbbc015b9092d41d480fb202de62db2a9b629304e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8bb3270365893e046581536ca68247bc076db996792d6e12276076043dc353b"
    sha256 cellar: :any_skip_relocation, ventura:        "3ccd7deee49ca74c101c186ba01eb2bfbcfc0584b73beabb937bf1b95fd367d3"
    sha256 cellar: :any_skip_relocation, monterey:       "e2fb94f5c26f62ba93143a24ede11996f1c6ed95b471012284f8c03feb764a45"
    sha256 cellar: :any_skip_relocation, big_sur:        "156af560dbd95b6265fc5eea98d8f8c543c3273033ee92f99bff4d0128cb01d4"
    sha256 cellar: :any_skip_relocation, catalina:       "7aab9e4151373680365e78a39474493b6a381bc8a24ad55a6c232018fe4644f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "936ac3ad8df5dae23a2ad663ceceeaa67c9b68862dab3d92d8d13235bf0d080a"
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
