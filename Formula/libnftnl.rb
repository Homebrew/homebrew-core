class Libnftnl < Formula
  desc "Netfilter library providing interface to the nf_tables subsystem"
  homepage "https://netfilter.org/projects/libnftnl/"
  url "https://www.netfilter.org/pub/libnftnl/libnftnl-1.2.3.tar.bz2"
  sha256 "e916ea9b79f9518560b9a187251a7c042442a9ecbce7f36be7908888605d0255"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "94764c454e993ee303396d1260a55dd173d0437f67cebc1e652c2bbba6ee6bd5"
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
