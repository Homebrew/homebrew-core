class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.36.orig.tar.gz"
  sha256 "7fe3cf3daf95ee93b47e568e85f4d341a1f9ae91766b4f9a9cdc29737dea4988"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c875e03e0332a8388aa7c7e3cc65f02e86b5201901a9ead41dd3cb2673e4926f"
    sha256 cellar: :any,                 arm64_sonoma:   "80043e6984e18e1b11a6b02c417ca6610e3d26048527d6a26cac067a41dc9931"
    sha256 cellar: :any,                 arm64_ventura:  "abb4abee538f323c11edf2c9fcdbc76fcef2c801acec80c8b4c57337ab382552"
    sha256 cellar: :any,                 arm64_monterey: "220f73a57d671e1b8c5f2d0af59994262ae2ac4675d4963e268c478ae9e83cf9"
    sha256 cellar: :any,                 sonoma:         "de7d02b93ec6cdb0cd7f261f389439cb8e2c1d985ba1fa79a4a1e4bbf4645c35"
    sha256 cellar: :any,                 ventura:        "1314a7bf8e17fd301a06a6553eb6cc2a29378d7ea89f0f6252119d1f748ff7a5"
    sha256 cellar: :any,                 monterey:       "90d9a9307beb5dd403fa6d3b86df350895342380d1d5304c9c54434a26d792ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73c47dd5b846fa6f73ebc8197d1b3d6a0ce8d6028f23ff0c2c1c733360171803"
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
