class Libnftnl < Formula
  desc "Netfilter library providing interface to the nf_tables subsystem"
  homepage "https://netfilter.org/projects/libnftnl/"
  url "https://www.netfilter.org/pub/libnftnl/libnftnl-1.2.5.tar.xz"
  sha256 "966de0a8120c8a53db859889749368bfb2cba0c4f0b4c1a30d264eccc45f1226"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/libnftnl/downloads.html"
    regex(/href=.*?libnftnl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4f3d2a56a6f6c1c131e9502fa424e6e89d16d580d163f28b05f33a3582b7bbca"
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
