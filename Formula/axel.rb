class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/archive/v2.17.6.tar.gz"
  sha256 "37ff029ef3645a618749734dfabde9f82976a51c04274ae0a167a7cce5005422"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    sha256 "8fe00eb038cef32171dc01872a2e5b39f23c26cab473f07a2abf8a2687b6db91" => :mojave
    sha256 "bfbf134d645d02caa73b768eec3aa0fe70fb571a30f6614dba551727101fbf74" => :high_sierra
    sha256 "aef5edb4248938590426081822d6e6f996c0e463c3b860a88b3a8943e678a84e" => :sierra
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
