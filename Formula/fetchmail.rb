class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.22.tar.xz"
  sha256 "cc6818bd59435602169fa292d6d163d56b21c7f53112829470a3aceabe612c84"
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
    sha256 cellar: :any, arm64_big_sur: "34af2028cfce9981b15e8b421f2aab1d3ff37e26d7a8ae35a4b5da4a83496447"
    sha256 cellar: :any, big_sur:       "b2eb430e9c0b89a09282e49f733acf024e00da80e7899f3732b5710cee0f38d8"
    sha256 cellar: :any, catalina:      "7c6643a842e07c933835f9dce0e79b777aa4b6c65f546b06bab8aa0604a56128"
    sha256 cellar: :any, mojave:        "42d4e7ac151260d638a0b688acbc1bb8ec83a6379ded29a8ecc04f1cea250528"
    sha256               x86_64_linux:  "19abe963e79a93c7a422681b01dc49a39bca05676cc97c94be5028562d1708ab"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end
