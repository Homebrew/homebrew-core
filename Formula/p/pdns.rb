class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-5.1.2.tar.bz2"
  sha256 "6855967a54ad7b5de89f910f05e348e317b2ed839eb498f96c38c1af7a1eaf38"
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
    sha256 arm64_tahoe:   "6e7f047a9cc14075e55519a4efaf728243d208e99e77dc1713f005044c17bec6"
    sha256 arm64_sequoia: "47fd917e0f52b808ecff3f4fee93a76fdb315d3edfde019c2548eb01f11a69b1"
    sha256 arm64_sonoma:  "a65e04663378be4200c40b9b08e525c953b32b9e6c167cc8d94f31f3ef303f41"
    sha256 sonoma:        "05bd5f8fef5ea203347431a94511f41c6b1b3cab5c01021fa92ceb90c06b0a17"
    sha256 arm64_linux:   "a1f9e5ee5b242ae21d942443ed588ccda58a557a60751dcce02e81f4d6d856f4"
    sha256 x86_64_linux:  "f8cd9db1a08ff435978b094125500bc2f50753250f73b27392cfefcf4fcc8d65"
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
      --with-libcrypto=#{formula_opt_prefix("openssl@3")}
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
