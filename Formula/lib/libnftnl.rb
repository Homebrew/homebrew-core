class Libnftnl < Formula
  desc "Netfilter library providing interface to the nf_tables subsystem"
  homepage "https://netfilter.org/projects/libnftnl/"
  url "https://www.netfilter.org/pub/libnftnl/libnftnl-1.2.6.tar.xz"
  sha256 "ceeaea2cd92147da19f13a35a7f1a4bc2767ff897e838e4b479cf54b59c777f4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/libnftnl/downloads.html"
    regex(/href=.*?libnftnl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "785bbe57269cdf996d7f156874c1b2ed1bafef79d337ed9d370529b2c0fc294b"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "libmnl"
  depends_on :linux

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
    pkgshare.install "examples"
    inreplace pkgshare/"examples/Makefile", Superenv.shims_path/"ld", "ld"
  end

  test do
    pkg_config_flags = shell_output("pkg-config --cflags --libs libnftnl libmnl").chomp.split
    system ENV.cc, pkgshare/"examples/nft-set-get.c", *pkg_config_flags, "-o", "nft-set-get"
    assert_match "error: Operation not permitted", shell_output("#{testpath}/nft-set-get inet 2>&1", 1)
  end
end
