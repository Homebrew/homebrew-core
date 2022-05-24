class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-9.01.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-9.01.tar.gz"
  sha256 "b3d7faf830e9793299d6a41e81d84cd4a3e2789c148c9e598e4585010090e4c7"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.infradead.org/openconnect/download.html"
    regex(/href=.*?openconnect[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "914669c733fc8e8c16d7bbf18dca0449660a81101b4e9c4c221ad95bfdf792d4"
    sha256 arm64_big_sur:  "2313cbe133b89a1634ad3d1759af956010e87afe21e35d9e01b0aa998583980d"
    sha256 monterey:       "5bbe2cd51c2bf848b0cdf81e4c3a0d386fe151517ed1badbd2dcd1bce7e67787"
    sha256 big_sur:        "1d6ff662f32e30eed582496d36784ba2ad31192653c6c326bf66c4e5136c3c37"
    sha256 catalina:       "e4ba32628105be93256386fd9592cf5c0c922536d17464d86c4a27c4c011f60d"
    sha256 x86_64_linux:   "184a0a3f7a6a14b73d7fcab1e26ee92dba2fe56927e43c26f25816c73041c19b"
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "stoken"

  resource "vpnc-script" do
    url "https://gitlab.com/openconnect/vpnc-scripts/raw/43195c25fd6aaa4d50f42c2dc51e53cf1b0baeb0/vpnc-script"
    sha256 "48abc54ad462e70ed0e29ca525a33e1d58cf90651e80e49b7d4ff0aaaaeb68b5"
  end

  def install
    etc.install resource("vpnc-script")
    chmod 0755, "#{etc}/vpnc-script"

    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-vpnc-script=#{etc}/vpnc-script
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "POST https://localhost/", pipe_output("#{bin}/openconnect localhost 2>&1")
  end
end
