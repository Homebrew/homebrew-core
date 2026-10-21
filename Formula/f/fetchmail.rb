class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.6/fetchmail-6.6.9.tar.xz"
  sha256 "3dfc47192e76099b5614f2b2a42198cb41fa05d7ca9b5073e08c051e9be81435"
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
    sha256 cellar: :any, arm64_golden_gate: "d73e6f6617ba37eefa3cbe7473ef752229193c7912a7869b6b05a60032d00e5e"
    sha256 cellar: :any, arm64_tahoe:       "c5fb4e5a482ba203a4ff910696d66399f4d63f871e56f4ead0baa39f3c05dec9"
    sha256 cellar: :any, arm64_sequoia:     "579119bde71dd04cb5cbd4aa7cd4a7213ae101bda9025ea6efa8593fc22ca5a1"
    sha256               arm64_linux:       "e9376ab8d1eb0cda50af972ee9f251c0e07120fc2d9255e95150101fc8af076d"
    sha256               x86_64_linux:      "e41888244da07c21886aea359dc96d1701b7219982ddf7c7c38e8f635f6f4695"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  deny_network_access!

  def install
    system "./configure", "--with-ssl=#{formula_opt_prefix("openssl@4")}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fetchmail", "--version"
  end
end
