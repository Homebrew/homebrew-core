class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.37.1.2.orig.tar.gz"
  sha256 "959496928c8a676ec8377f665ff6a19a707bfad693325f9cc4a4126642f53224"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "63ce046cb14a93fb98404df474b78719690cac86466b66b3cf0af93e2a16cf80"
    sha256 cellar: :any,                 arm64_sonoma:  "8ea63218b4c5fdb3065b1b8e0523a41285d92ea9bda60b1aa2a13e187676a74c"
    sha256 cellar: :any,                 arm64_ventura: "516f46bd515171543b2d7c61bda37d5d777932ed480bc2115c4aa62282ae02db"
    sha256 cellar: :any,                 sonoma:        "81d3b0da803e489894fae1d290d78ba1abffbc384f70fc99d3e95d41aebbb4fa"
    sha256 cellar: :any,                 ventura:       "b1ca3e8b74313638583ba460578349747d83aca0fd02d9fab62c499cb5104cc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffd98968fac850868f65247322949c7b2f9ea381f025ad25a3eecbc518f29a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c8783d27616cc745b74cd2d25b851c38592ebcd2a5f6c60f577087d032a7ce1"
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
