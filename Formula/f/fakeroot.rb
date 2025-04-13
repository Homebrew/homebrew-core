class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.37.1.1.orig.tar.gz"
  sha256 "86b0b75bf319ca42e525c098675b6ed10a06b76e69ec9ccf20ef5e03883b3a14"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a0f7addfdc6d501b66e2b06354e3b908ba99bdbc24aad71d47dd7d69d19ba502"
    sha256 cellar: :any,                 arm64_sonoma:  "93c322f3d6952ee77fe109e6c809fd171d5446473ba1e172374fffcb3c988574"
    sha256 cellar: :any,                 arm64_ventura: "0c554452142dd13cef6396126d3bb79a7a082bd511e35082b01447dab1557369"
    sha256 cellar: :any,                 sonoma:        "1e1753fab9fce0fbf19cd037fd3a5ebc0eaa7553854c056a771278a916484f8d"
    sha256 cellar: :any,                 ventura:       "ec92b030562cfd54b9958b2a14cba38d5600699015704e4072825cf56b3c1f8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0755498e4b8e590507a1d1f1c9e23e23cb50152bc691be49ad08d8e160e2bd72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72b86fc8862a9f301796d52231d7dfa754d396edb3ac9ee7cbc2be6095b36569"
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
