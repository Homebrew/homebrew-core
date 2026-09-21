class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.6/fetchmail-6.6.7.tar.xz"
  sha256 "bece8aaaa68e029eed9fd55fffd2adc7dd6cd5e9574d5bf92e2d9208bd97a881"
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
    sha256 cellar: :any, arm64_golden_gate: "a693672990f0580502e462db6f854eaddca2cf9689a8faffc376b051f0c5b823"
    sha256 cellar: :any, arm64_tahoe:       "184a225b972384b3c590832140a6953e6ab980be58bc98177bc7900e7750f7e9"
    sha256 cellar: :any, arm64_sequoia:     "e4f9117e236ba5608cef7d3f5c750da588025f19aece9144cfe13b5679c87e54"
    sha256 cellar: :any, arm64_sonoma:      "14dc7d00848c892e6d8b5af31e4b3144a29979c1fcf7facce4dcfecf38cf4d35"
    sha256               arm64_linux:       "b04b452658dfbc6e828f9087dcfe1105dd8697d387c939453f2774f7472e07be"
    sha256               x86_64_linux:      "f05ce58cf6c07dc8db1cfce1efd59459e841879d6541b12400c563f8424c7a3e"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{formula_opt_prefix("openssl@3")}"
    system "make", "install"
  end

  test do
    system bin/"fetchmail", "--version"
  end
end
