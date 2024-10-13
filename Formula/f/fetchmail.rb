class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.39.tar.xz"
  sha256 "75109a1f307b538155fa05f5ef298e8298cb4deae95aed24c16b38d36ff0a186"
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
    sha256 cellar: :any, arm64_sequoia:  "531a98d2af949d23b2de33b7e9cedfe3c7aa39a49d59f52023531d3184ba6119"
    sha256 cellar: :any, arm64_sonoma:   "91549ee97ce356ed5b3b7004a06f04195d528413f2dbf02fdda99cac0c162090"
    sha256 cellar: :any, arm64_ventura:  "104754306bfc7cf87ab281d313496931d9b34252efdf981e512dbd1d4f101e0c"
    sha256 cellar: :any, arm64_monterey: "6cdcdf18636df7649a006751f4f2e0c548c6d1d23f687dcb8ae57caf9402040b"
    sha256 cellar: :any, sonoma:         "ea579492596d6f2972e800ebbaf5936dad15801a64b61d6bd7af4f1da05461ca"
    sha256 cellar: :any, ventura:        "b1bfc5a0f4903f38135411c86eeb8e800e413a5c3f4209d7d992fa12d786e5d4"
    sha256 cellar: :any, monterey:       "0910b99beb30cdae8fed6132f2d8dd934d4d0210b8b83e01a4a7902e0203a95e"
    sha256               x86_64_linux:   "913eaf667d5718b8b1a58ccc8d3c531dc45257ae0e8cbb23304d283daf30f91c"
  end

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
