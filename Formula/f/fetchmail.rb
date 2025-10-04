class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.5/fetchmail-6.5.6.tar.xz"
  sha256 "ec10e0e0eaa417313559379ede76c74614766d838b39470b66474863aa690dab"
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
    sha256 cellar: :any, arm64_tahoe:   "bbbeb15ec10bcc29516f3a4f96cb4a906baaea54fb9b7fec53909048d2ac6bfb"
    sha256 cellar: :any, arm64_sequoia: "74709f66cdc31a33eecdaab5e373c3a05edc03cae3dcc7d33910650e63b408e6"
    sha256 cellar: :any, arm64_sonoma:  "9af541e86cb257e21358be6ad87002f87f2278fce32b754f404915ca68c71d84"
    sha256 cellar: :any, sonoma:        "a33e56f3b1b328dd1e0ef6577765c4578b690baac0567de2c3269717a7fbbfb2"
    sha256               arm64_linux:   "475e701040bb7b20d9b2b9466236ac6a379a3cf8be53932c367b5df3982eb0b9"
    sha256               x86_64_linux:  "95c209d0c4e15e1402ed56db8763394bdf2e5694ab0437fe4ae1a6804f66a356"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"fetchmail", "--version"
  end
end
