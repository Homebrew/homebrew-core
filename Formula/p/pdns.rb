class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.0.1.tar.bz2"
  sha256 "c45f91a08d343410e992ce887edcf560c4544bae07472da1a00aa8ae418a67af"
  license "GPL-2.0-or-later"

  # The first-party download page (https://www.powerdns.com/downloads) isn't
  # always updated for newer versions, so for now we have to check the
  # directory listing page where `stable` tarballs are found. We should switch
  # back to checking the download page if/when it is reliably updated with each
  # release, as it doesn't have to transfer nearly as much data.
  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4b38511a3291c2e60cb6492d83db9cae10d165609e747356dcbcd5a63e5d71d0"
    sha256 arm64_sequoia: "4855e6e77c7ff191c7249495b9c8431cfa5f0093a58a328525970d8566780119"
    sha256 arm64_sonoma:  "2c73b8873813d7a1a14db937ff6d73179e97b3259e8c5b25f6bf004000d85f30"
    sha256 sonoma:        "965470420b62bb065908f22476b18c70ca0770ad959eccb49985cec556d3de1a"
    sha256 arm64_linux:   "c0fb2f1508f8d78cf236aef6b6455cc0dc92bee90530cc9d339878b79dd13a70"
    sha256 x86_64_linux:  "9e73a05aaac16867baceb140fd261ab5b67e01061d6fc8c5af3d32397b1dfe77"
  end

  head do
    url "https://github.com/powerdns/pdns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "sqlite"

  uses_from_macos "curl"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
      --with-sqlite3
      --with-modules=gsqlite3
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin/"pdns_server"
    keep_alive true
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1")
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end
