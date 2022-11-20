class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.29.orig.tar.gz"
  sha256 "8fbbafb780c9173e3ace4a04afbc1d900f337f3216883939f5c7db3431be7c20"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "52c8c0df164c33131f151529ad3abae12c40afb58c25f3b2118e6003289c6b22"
    sha256 cellar: :any,                 arm64_monterey: "7e0e4ef8f43b55ea24a0e11b436b96263af4ab80c8a90b39d1e4d479633a31fb"
    sha256 cellar: :any,                 arm64_big_sur:  "38e3a802475e1ca4a146a7144f84e94925257331761bf841218e557f0556f988"
    sha256 cellar: :any,                 ventura:        "6e061df8a3faff41f686699d9961e598c1715a5a9ee75a41aca5dfd1ca2a2577"
    sha256 cellar: :any,                 monterey:       "2522875d0b65d593eebbeecf71e5ed9fe38e3a911abce60db45bbfd1ec5a139c"
    sha256 cellar: :any,                 big_sur:        "8e0d19fe2fa84595407862beca5457a1b258d48eda689bd1cb0ca84fb966f7f1"
    sha256 cellar: :any,                 catalina:       "ec8a523ac84e27ebb81e3cbc41b619fb8fb7cf4858c6d2ada62c2b39a3461885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fe66fdf8d3f3c8207fde2c98b5af0562101a38ab164b0a85ae803d7c382abc7"
  end

  # Needed to apply patches below. Remove when no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "libcap" => :build
  end

  # https://salsa.debian.org/clint/fakeroot/-/merge_requests/16
  patch do
    url "https://salsa.debian.org/clint/fakeroot/-/commit/e1a7af793e58bddd4bbd04cfb4d26687fbaa9bcf.diff"
    sha256 "60cfd8bbc416527981151237b7c403fba88975e97907a0ed5c31566d0cda078d"
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
