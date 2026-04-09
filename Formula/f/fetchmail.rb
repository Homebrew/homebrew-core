class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.6/fetchmail-6.6.3.tar.xz"
  sha256 "246e5fc0e35c93dde1a3fb66778e3ab700e16809232e4959c508b91214374bb2"
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
    sha256 cellar: :any, arm64_tahoe:   "8e268a2e4d729295f3fe7227c0bf2e42b7555fcc09edc2b54fe521ba6c7f931e"
    sha256 cellar: :any, arm64_sequoia: "b37b9d141182eeafcdc2570c5548e2faca9a50fce01f4b87c5dc91a8a21fae67"
    sha256 cellar: :any, arm64_sonoma:  "69a433c666e42e7ecdfa05ba29adffa703dded908cd3ddbe40c12b2da27fcd3e"
    sha256 cellar: :any, sonoma:        "f1510bdca1db2f307f2d304311a294c8b52f3858637b3312528c3236b96e2a45"
    sha256               arm64_linux:   "5935569083d557b380316e7f77331346d43c573978a7addaf9506076a457cf67"
    sha256               x86_64_linux:  "e00292c1ff76edd4ddbd97290dd8e956594b8df5c13e8f1e391f82ab0417815c"
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
