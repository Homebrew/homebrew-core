class Libnftnl < Formula
  desc "Netfilter library providing interface to the nf_tables subsystem"
  homepage "https://netfilter.org/projects/libnftnl/"
  url "https://www.netfilter.org/pub/libnftnl/libnftnl-1.3.2.tar.xz"
  sha256 "c97abc3409f8fa396b4462b2bb7f147a3a47a4ddc97cfa0b2f18890c9cfde8b0"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/libnftnl/downloads.html"
    regex(/href=.*?libnftnl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "8bb88e18c2ec7f3ee73a0b4dff7c70bcafb1f837486d1f97284e8e028486a3ce"
    sha256 cellar: :any, x86_64_linux: "3b2e888c2d03cd2f07f1eac05e3e406aea7004d1499bbe96a08ce5230063366e"
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
