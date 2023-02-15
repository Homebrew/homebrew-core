class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.31.orig.tar.gz"
  sha256 "63886d41e11c56c7170b9d9331cca086421b350d257338ef14daad98f77e202f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aedceb09368601f72b1faf40c4d99500666a0f56f8790517232062a8e9c71998"
    sha256 cellar: :any,                 arm64_monterey: "be2bc267bd36107015417f9bc50d00f4f588719f592ecc90b8e1a022d02c98a2"
    sha256 cellar: :any,                 arm64_big_sur:  "f7e804656c5fef0d0b3608694c09a422b92e640a808b2757eca874ac39781932"
    sha256 cellar: :any,                 ventura:        "f9b9aa5ef732b108c4061ec856e086352b37eee26e8cb7fe4e323ebf18a9a565"
    sha256 cellar: :any,                 monterey:       "433eaab3292da30f2efe0ccdd98e329a787366b33b3b72bef7426d7bbb7868c5"
    sha256 cellar: :any,                 big_sur:        "1a7020f1cd33cdb0a48e3af18486ec91eb85b938953e21b37808e29150a12b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c0c27baa67937807bf7c6a141443930a76cd51bfb2b757f5d5d9582c1653a92"
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
