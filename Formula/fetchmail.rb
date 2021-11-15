class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.23.tar.xz"
  sha256 "5f7a5e13731431134a2ca535bbced7adc666d3aeb93169a0830945d91f492300"
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
    sha256 cellar: :any, arm64_monterey: "9b0561ee39f9a440fcc0ad760fdbac0791cca487371bc8675dd92786eed955e0"
    sha256 cellar: :any, arm64_big_sur:  "0e0f7cff073d7dcf3b6c8a20c9dbf811924500c827b7252674fe2a85a34b82fe"
    sha256 cellar: :any, monterey:       "05f4a1693344f655b09472d4bf9b072b4035b3042cc73c5bdc5aa3adc564d9c7"
    sha256 cellar: :any, big_sur:        "cd66b9f37fdb2d1c80b37a6dd5c05f809c3dedebd1491e739a4465e01c4e7a32"
    sha256 cellar: :any, catalina:       "368ea10abfbc0cef637aa62f49f183a7b96349c18015f494e361dac5586edfc1"
    sha256               x86_64_linux:   "512b434776b4c1783c1a154acf0f9891c5848050fb6ede3b8b736546d579b893"
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
