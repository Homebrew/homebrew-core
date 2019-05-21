class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/archive/v2.17.3.tar.gz"
  sha256 "13cc30194a2d52cdb87b0deca6e472ac75fbb2d8af72d554ba3936f1e2a416a7"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    sha256 "adeae5381b5f2af22d603fbb6fac26db979bba83594ed3a3df1f37111052242d" => :mojave
    sha256 "2cf88b747ac4b3e70e20248993abbfc4e00ada9acbab151f8df333901394ca23" => :high_sierra
    sha256 "509b1d7f66f4cd73750f6aa67e6cf081d53b358d78c2b7a489d9854b76042c84" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl"

  def install
    # Fixes the macOS build by esuring some _POSIX_C_SOURCE
    # features are available:
    # https://github.com/axel-download-accelerator/axel/pull/196
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_predicate testpath/"axel.tar.gz", :exist?
  end
end
