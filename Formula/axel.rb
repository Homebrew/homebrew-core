class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/releases/download/v2.17.6/axel-2.17.6.tar.gz"
  sha256 "15be4803789d8a3b0aa7ea9629a21ea56ff46ea5d8b484004a00826d4ffcbd00"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    sha256 "9973ae6cfb5268af7a9d491982556f60ec46e2730e4e89588a961e616dd5ad81" => :catalina
    sha256 "3a8739384fae93ad6e50c385c4d59741ef1e69683800ccc113f2da454928724e" => :mojave
    sha256 "d336f8022358b2988ffae7836a6cd0b7d7fe87c9f234fee18e571a81d05a0ac7" => :high_sierra
    sha256 "2e1536b5844d888daa112c9f19290da1bdeb305a57c66bff0188251ec8856df2" => :sierra
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
