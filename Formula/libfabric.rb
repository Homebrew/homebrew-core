class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.12.0/libfabric-1.12.0.tar.bz2"
  sha256 "ca98785fe25e68a26c61e272be64a1efeea37e61b0dcebd34ccfd381bda7d9cc"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5ff8006f95b58535cccc2ad7b2f2b4ba66888c103dfb459d96dde05feee8c4ff"
    sha256 cellar: :any, big_sur:       "cc6aa253fb948b77386ce7fdc5c64ced7fa2a0d31c1b248c39f3815e5cc577eb"
    sha256 cellar: :any, catalina:      "2309aec7c76635a8cdd18f79e0abac6cf8ff1813857958d9dfab280e5245a244"
    sha256 cellar: :any, mojave:        "1b854ecd4b7a50023f7c96f5e3784aae452f48eb02ee84e427d2cb72691263a0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "provider: sockets", shell_output("#{bin}/fi_info")
  end
end
