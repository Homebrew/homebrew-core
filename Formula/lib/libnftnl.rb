class Libnftnl < Formula
  desc "Netfilter library providing interface to the nf_tables subsystem"
  homepage "https://netfilter.org/projects/libnftnl/"
  url "https://www.netfilter.org/pub/libnftnl/libnftnl-1.3.1.tar.xz"
  sha256 "607da28dba66fbdeccf8ef1395dded9077e8d19f2995f9a4d45a9c2f0bcffba8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/libnftnl/downloads.html"
    regex(/href=.*?libnftnl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "932090d305277e1510df58cdbe16b545b9f565a6c8a6c646a5465af48288ad9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "86af24831e02ee43a05182f3028d424ce8cb2c2a4ff34ec23652532a63986bfc"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libmnl"
  depends_on :linux

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    pkgshare.install "examples"
    inreplace pkgshare/"examples/Makefile", Superenv.shims_path/"ld", "ld"
  end

  test do
    flags = shell_output("pkgconf --cflags --libs libnftnl libmnl").chomp.split
    system ENV.cc, pkgshare/"examples/nft-set-get.c", "-o", "nft-set-get", *flags
    assert_match "error: Operation not permitted", shell_output("./nft-set-get inet 2>&1", 1)
  end
end
