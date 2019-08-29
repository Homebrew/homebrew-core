class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/archive/v2.17.6.tar.gz"
  sha256 "37ff029ef3645a618749734dfabde9f82976a51c04274ae0a167a7cce5005422"
  head "https://github.com/eribertomota/axel.git"

  bottle do
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

    gettext = Formula["gettext"]
    openssl = Formula["openssl"]
    ENV["PATH"] = "#{gettext.opt_bin}:#{ENV["PATH"]}"
    ENV.prepend "CPPFLAGS", "-I#{gettext.include} -I#{openssl.include}"
    ENV.prepend "LDFLAGS", "-L#{gettext.lib}"

    system "autoreconf", "-fiv", "-I#{gettext.share}/aclocal/"
    system "./configure",
              "--disable-dependency-tracking",
              "--prefix=#{prefix}",
              "--sysconfdir=#{etc}"

    system "make", "axel"

  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_predicate testpath/"axel.tar.gz", :exist?
  end
end
