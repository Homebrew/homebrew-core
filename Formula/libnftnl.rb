class Libnftnl < Formula
  desc "Netfilter library providing interface to the nf_tables subsystem"
  homepage "https://netfilter.org/projects/libnftnl/"
  url "https://www.netfilter.org/pub/libnftnl/libnftnl-1.2.4.tar.bz2"
  sha256 "c0fe233be4cdfd703e7d5977ef8eb63fcbf1d0052b6044e1b23d47ca3562477f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "607c140572fe20418d5413e69cf77a5474445ee6a49d83c3598cc291b89ab518"
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
