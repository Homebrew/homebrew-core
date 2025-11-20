class Links < Formula
  desc "Lynx-like WWW browser that supports tables, menus, etc."
  homepage "http://links.twibright.com/"
  url "http://links.twibright.com/download/links-2.30.tar.bz2"
  sha256 "c4631c6b5a11527cdc3cb7872fc23b7f2b25c2b021d596be410dadb40315f166"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "http://links.twibright.com/download.php"
    regex(/Current version is v?(\d+(?:\.\d+)+)\. /i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "61bcbe87200f27fd2e77adc5e4b54fd5937f60732b69b56d68cb3659c62c3ca3"
    sha256 cellar: :any,                 arm64_sequoia:  "8b643d830760363e4ff40491b2c1476dfdd28cdfbf1d2290f6a33ef8b025f717"
    sha256 cellar: :any,                 arm64_sonoma:   "b73e7b5fcce9fa2b81c1d05c3ad32e5e891c548f5c4980e6e44e674930680f5b"
    sha256 cellar: :any,                 arm64_ventura:  "1e3c4427a90752290d9277535ed94089b9ecef307afa6d8853c643b4e9b01fd3"
    sha256 cellar: :any,                 arm64_monterey: "5a1c32ba972a310b39aea75b5025652f0dfac0e673b0a72ac201ca98b9afd0e1"
    sha256 cellar: :any,                 sonoma:         "5a3d86b0541eb8d09cb5b704967a44a8b78f691185b678096ff1cb82c019a2dd"
    sha256 cellar: :any,                 ventura:        "9ccae93d12e61c3c65069c915d5fef38e61f8f40d3e984de2b4a3867d55b3106"
    sha256 cellar: :any,                 monterey:       "4f077dd57e8eab5969cf9382c5a262eaba325b48fa68e8ad8f9221bebedeab43"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1f2ee4a9703ed6de5122fac5f7b4ad3bf81853366f500e3487dffde0025c03e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4e5d1f0bddfee851800eedbefc4a4e97d7563cc00910ecf74ddcdce4b56a415"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", "--mandir=#{man}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          "--without-lzma",
                          *std_configure_args
    system "make", "install"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"links", "-dump", "https://duckduckgo.com"
  end
end
