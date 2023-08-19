class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.32.1.orig.tar.gz"
  sha256 "c072b0f65bafc4cc5b6112f7c61185f5170ce4cb0c410d1681c1af4a183e94e6"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c2c947fbda3a3f11f6ca1b213254a580921090f29a252bafe4ea081566a547cc"
    sha256 cellar: :any,                 arm64_monterey: "e14ba003ef606ed05ee1f50d4ba8824641ca5c3b882e58c8952083d8e3184710"
    sha256 cellar: :any,                 arm64_big_sur:  "6c83a70fa4bf0f9d3b402ef1a26826ec1b6e8d077e2edfbe062d53c21b786c7e"
    sha256 cellar: :any,                 ventura:        "2c447719b73e0f9922b4f53457df40d9b38bc199189b728267e4487ad5bd9caf"
    sha256 cellar: :any,                 monterey:       "71680219b0aa0cbdc4732c4e5faf4f47c1189952a77b0dd54e2c6bb658a968d2"
    sha256 cellar: :any,                 big_sur:        "bd41e5935ee6abcca00e902c500e4825742253367b8f006e58f70268a46f3c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8016d933ec9d8778028ff2eb56f1fd2432698488c33ca09d8c98d1b8e14427fe"
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
