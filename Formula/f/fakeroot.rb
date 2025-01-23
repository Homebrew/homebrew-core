class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.36.2.orig.tar.gz"
  sha256 "92ee28cd75ef17a178bb06d9b9f57fb54b068b6a72d4710cccfe8453701c734f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d996f780f22a39b0e3ea1caa2d36cf04dc5b911646d660005720eee664168de1"
    sha256 cellar: :any,                 arm64_sonoma:  "26b1afc9d02feef810a11736a389f46b88d997a81cd2713f94c47ec84a5b0da8"
    sha256 cellar: :any,                 arm64_ventura: "687a5410e011030703e4ee250067545f31cdb0509c1277bbbd038dda7266ec03"
    sha256 cellar: :any,                 sonoma:        "921f6e353c931cd8364d8e656bf107d49845df1c9b618d24c3315e50b0fd671d"
    sha256 cellar: :any,                 ventura:       "3c21764bf649e641c9f3a3296bb2b8e4a89d52d7752d9e2f8b5dcf479190eb9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a52781c0a99b8debae48e4660bf4076d748271c3e5278901db4cdd4002a21c2f"
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
