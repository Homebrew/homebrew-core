class Libnftnl < Formula
  desc "Netfilter library providing interface to the nf_tables subsystem"
  homepage "https://netfilter.org/projects/libnftnl/"
  url "https://www.netfilter.org/pub/libnftnl/libnftnl-1.2.9.tar.xz"
  sha256 "e8c216255e129f26270639fee7775265665a31b11aa920253c3e5d5d62dfc4b8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/libnftnl/downloads.html"
    regex(/href=.*?libnftnl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "115eff122c8a59428839095a6c47ee36fcc60efb1fe28a6ce1c9120e32213641"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7077fb58a3c953a76ee5c54dd05a72005432161e9f9db04678e8d621c85e2dc6"
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
