class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.6/fetchmail-6.6.10.tar.xz"
  sha256 "f32f1ecfdb99a243b6f7fef5d1b5f5aeac2bb0a45ce0162552d6063db3b48073"
  license all_of: [
    "LGPL-2.1-or-later",
    "ISC",
    "BSD-3-Clause",
    :public_domain,
    "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" },
  ]

  livecheck do
    url :stable
    regex(%r{url=.*?/branch_\d+(?:\.\d+)*?/fetchmail[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    manifest_sha256 "0be9d734bd938b9b0d6abe1c6db3167c55f23b70214722c3c04a8ea02b8a347e"
    sha256 cellar: :any, arm64_golden_gate: "ce723917e9a8c9b2a80b1e4afedcc6fec2b8c00508aec0083c3453d215ebda7a"
    sha256 cellar: :any, arm64_tahoe:       "239e8a9cb4f63a6a6047b9bfb91169074020342118113f1822797a169c1687a0"
    sha256 cellar: :any, arm64_sequoia:     "ceae391e272427f2a4ea9b81f261dacc3af1835d5639f61ed17bd8079261f535"
    sha256               arm64_linux:       "19aa73231cc5ace1d12028e461d5e419a07086a5c45d58ca261f0b4ce11a651a"
    sha256               x86_64_linux:      "bf7a5f7a4ba4604b30d8255219f3e33a360de5db1f69597c96f5d49236532a9d"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  deny_network_access!

  def install
    openssl_prefix = dep("openssl").opt_prefix
    system "./configure", "--with-ssl=#{openssl_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fetchmail", "--version"
  end
end
