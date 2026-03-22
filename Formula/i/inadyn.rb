class Inadyn < Formula
  desc "Dynamic DNS client with IPv4, IPv6, and SSL/TLS support"
  homepage "https://troglobit.com/projects/inadyn/"
  url "https://github.com/troglobit/inadyn/releases/download/v2.13.0/inadyn-2.13.0.tar.xz"
  sha256 "d08ca63a35896f2a809ba9b704da16ec6812b94dd410e7b3ea536a16d93860c2"
  license all_of: ["GPL-2.0-or-later", "ISC", "MIT"]

  bottle do
    sha256               arm64_tahoe:   "367aa7d309e7a4f0ea0396792677dbc85c26e710b0bc0589ccb0f6a7865e04d4"
    sha256               arm64_sequoia: "363f486f77bea677bfe94701445c59157b41be18c3bd0cebed32775a091f8c69"
    sha256               arm64_sonoma:  "6999bbd3d5ea2031ffb769ba760e8773135fd79f52ff491d0afd86990eba4df9"
    sha256 cellar: :any, sonoma:        "9be51be4af64cf15f78b1620e20e202e9b87203fe22283949c6dc4d8b84cd977"
    sha256               arm64_linux:   "7c25878f74b5f576c8419349760fb91ca8e691dac6f218d6a9ca13eb48513460"
    sha256               x86_64_linux:  "e8f29704c471eab3e75284a928a372b077f58193657c62d10b4d60476af8e14e"
  end

  head do
    url "https://github.com/troglobit/inadyn.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  deprecate! date: "2025-10-25", because: :repo_archived

  depends_on "pkgconf" => :build

  depends_on "confuse"
  depends_on "gnutls"
  depends_on "nettle"

  def install
    mkdir_p buildpath/"inadyn/m4"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"inadyn", "--check-config", "--config=#{doc}/examples/inadyn.conf"
  end
end
