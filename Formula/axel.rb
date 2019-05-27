class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/archive/v2.17.3.tar.gz"
  sha256 "13cc30194a2d52cdb87b0deca6e472ac75fbb2d8af72d554ba3936f1e2a416a7"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    sha256 "ee8290a5bebdc8dd004a01dc7ab79ddce852bc4ac116d2628eccd0233c6145a1" => :mojave
    sha256 "5653614b55d9ed7e0340ddf16bfea60934af1146d403eed4f7d54a3a7ab58501" => :high_sierra
    sha256 "7210f4ac81aa0689a2471ca5989bd03525bac13133ba25ebed7b234883cefd42" => :sierra
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
