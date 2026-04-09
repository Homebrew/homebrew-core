class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+TLS VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "c40d33acd97b89c2e943bfd839c19b69e5a7a5997052e2fc9a595602745c0465"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/adrienverge/openfortivpn.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "1cb3b9c06cf1b8af8984fe264878a82a0fe7b4f58ae0d0a90640a9ed37965a90"
    sha256 arm64_sequoia: "dc900e43087d6641174632f37b884dc806b6777546f3b0c9c45fecbdf1573886"
    sha256 arm64_sonoma:  "bd784e7336c8d86dbd91cbc9877122518fb8641720abbadf9480fd93381354ea"
    sha256 sonoma:        "445013d98ad9c0d85b93cbc56dba215ee5096660cf7c56b43643779685b2ab55"
    sha256 arm64_linux:   "b839b8ec4aa6c6c666c68f79571a2ec0ac0b73e1eef6d04c27943012484504e2"
    sha256 x86_64_linux:  "f977e5a39f774039ea8b06090d1b0e4459d3321233aa171a4b157e4d8419cbe8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  # awaiting formula creation
  # uses_from_macos "pppd"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--enable-legacy-pppd", # only for pppd < 2.5.0
                          "--sysconfdir=#{etc}/openfortivpn",
                          *std_configure_args
    system "make", "install"
  end

  service do
    run [opt_bin/"openfortivpn", "-c", etc/"openfortivpn/openfortivpn/config"]
    keep_alive true
    require_root true
    log_path var/"log/openfortivpn.log"
    error_log_path var/"log/openfortivpn.log"
  end

  test do
    system bin/"openfortivpn", "--version"
  end
end
