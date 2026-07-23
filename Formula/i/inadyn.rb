class Inadyn < Formula
  desc "Dynamic DNS client with IPv4, IPv6, and SSL/TLS support"
  homepage "https://troglobit.com/projects/inadyn/"
  url "https://github.com/troglobit/inadyn/releases/download/v2.13.0/inadyn-2.13.0.tar.xz"
  sha256 "d08ca63a35896f2a809ba9b704da16ec6812b94dd410e7b3ea536a16d93860c2"
  license all_of: ["GPL-2.0-or-later", "ISC", "MIT"]

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "c040b6d60834b73295049a0124ebf15ce755a386899c84c21cfc57aa54bff950"
    sha256               arm64_sequoia: "bc4129b27abce3362303430d69264aef4466b39b5e63529a535e6a2eccd3c09a"
    sha256               arm64_sonoma:  "00a282efc5c3f7878ab7dc2c7446feb60eaffd0bf0131d21ea7fbcc216f1b9dd"
    sha256 cellar: :any, sonoma:        "a8919f0ca46b3d3d9c4bb8aa28675ae842a251ba8f35d69930514d359e84d544"
    sha256               arm64_linux:   "42f252f8f4b39a3c3715931d8609525eae85fc9e6d3c78da08be98cb92e54388"
    sha256               x86_64_linux:  "ff6dfa66150cd7aa8a6f4f4c2c6fc543d39def05762f77b93680238d9b5cc80e"
  end

  head do
    url "https://github.com/troglobit/inadyn.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  deprecate! date: "2025-10-25", because: :repo_archived
  disable! date: "2026-10-25", because: :repo_archived

  depends_on "pkgconf" => :build

  depends_on "confuse"
  depends_on "openssl@4"

  def install
    mkdir_p buildpath/"inadyn/m4"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--enable-openssl",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"inadyn", "--check-config", "--config=#{doc}/examples/inadyn.conf"
  end
end
