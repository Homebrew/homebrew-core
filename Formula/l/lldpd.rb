class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://lldpd.github.io/"
  url "https://media.luffy.cx/files/lldpd/lldpd-1.0.21.tar.gz"
  sha256 "5b1b0106079a0785b55e1be45cec40b66b41779f3ee6f1a8d2dbd75d389df091"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?lldpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "32667ecb07946f013f028a50c58fb79c5fa3d50064cf855b06413049c6b4b5cc"
    sha256 arm64_sequoia: "45e89fcdccc4da7922243c2d8720f7ed9f814bc675e2b1ec06176a1c987e15a7"
    sha256 arm64_sonoma:  "dd1fb5f76d760abd34f15922a5f248401f2ecbd536cae651e1cae14b84a8d457"
    sha256 sonoma:        "68d8cf0453620eb9f8822c44e326a5ddfa2e96656e0208271a3b1d86cc6ffe50"
    sha256 arm64_linux:   "cb61c0fe87c9adb22e961d4c70bdfa102733b7752cc0fcb924a41fd62280528f"
    sha256 x86_64_linux:  "286581069fe7b41e790c6a3f79b732fd388a91e2d93d381ad5ade7b6d53fc43b"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "readline"

  uses_from_macos "libxml2"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-privsep-chroot=/var/empty
      --with-privsep-group=nogroup
      --with-privsep-user=nobody
      --with-readline
      --with-xml
      --without-launchddaemonsdir
      --without-snmp
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    (var/"run").mkpath
  end

  service do
    run opt_sbin/"lldpd"
    keep_alive true
    require_root true
  end
end
