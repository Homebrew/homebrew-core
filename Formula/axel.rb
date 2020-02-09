class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/releases/download/v2.17.7/axel-2.17.7.tar.gz"
  sha256 "b05e828fac19acb3bddb7d5e5af69617f29f34aea78dd2045cf30edc834cb4d5"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    cellar :any
    sha256 "f21813f4113f1c50d6c9c241210435f5db49e63136ada0beb4e6b13b71922b7e" => :catalina
    sha256 "ea45d5812240f3969a9ae75adedd25a37a133e38002d33a655ca1c46118f5153" => :mojave
    sha256 "8cdedff82eae38b9e34842d3546b48b5ad4729fa949bcbcdc6e194afa78fbcfe" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"

  def install
    # Fixes the macOS build by esuring some _POSIX_C_SOURCE
    # features are available:
    # https://github.com/axel-download-accelerator/axel/pull/196
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"

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
