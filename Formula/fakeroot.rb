class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.31.orig.tar.gz"
  sha256 "63886d41e11c56c7170b9d9331cca086421b350d257338ef14daad98f77e202f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1277bae525d048e13949050953ce76e8e202ce9d23a043c4c3df927472844f77"
    sha256 cellar: :any,                 arm64_monterey: "f557e4d5f1450380e3811d28d0b2f191b56a5b2a871b60666d77dbf7d07f03fd"
    sha256 cellar: :any,                 arm64_big_sur:  "c9f2f9937915755e83d2597b594d0a40446f64a981fe544be42d6555daa23d68"
    sha256 cellar: :any,                 ventura:        "284d3ba70005c25b614e5cad61b3f4e596b48c50620534ca84697364d9ba8142"
    sha256 cellar: :any,                 monterey:       "90a0e642332fd3e03c899dd7ec5be3a708f482b084de90c3e1d6d4569530173d"
    sha256 cellar: :any,                 big_sur:        "ad7ba23c1197dcae35a7017880077b0368c1d2254ddb2c6e71e03f3450b5baa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "802342f83f03be042fa8512d1f4080292523ecc83029428fd1c539dbcf83dd53"
  end

  # Needed to apply patches below. Remove when no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "libcap" => :build
  end

  # https://salsa.debian.org/clint/fakeroot/-/merge_requests/17
  patch :p0 do
    # The MR has a typo, so we use MacPorts' version.
    url "https://raw.githubusercontent.com/macports/macports-ports/0ffd857cab7b021f9dbf2cbc876d8025b6aefeff/sysutils/fakeroot/files/patch-message.h.diff"
    sha256 "6540eef1c31ffb4ed636c1f4750ee668d2effdfe308d975d835aa518731c72dc"
  end

  def install
    system "./bootstrap" # remove when patches are no longer needed

    args = ["--disable-silent-rules"]
    args << "--disable-static" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakeroot -v")
  end
end
