class LibnetfilterConntrack < Formula
  desc "Library providing an API to the in-kernel connection tracking state table"
  homepage "https://www.netfilter.org/projects/libnetfilter_conntrack/"
  url "https://www.netfilter.org/pub/libnetfilter_conntrack/libnetfilter_conntrack-1.1.0.tar.xz"
  sha256 "67edcb4eb826c2f8dc98af08dabff68f3b3d0fe6fb7d9d0ac1ee7ecce0fe694e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/libnetfilter_conntrack/downloads.html"
    regex(/href=.*?libnetfilter_conntrack[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ae07370b1802d6089195cb605b4010635126ca6f6f37d20023c5f19ff9b833e6"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "libmnl"
  depends_on "libnfnetlink"
  depends_on :linux

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
    pkgshare.install "examples"
    inreplace pkgshare/"examples/Makefile", Superenv.shims_path/"ld", "ld"
  end

  test do
    pkg_config_flags = shell_output("pkg-config --cflags --libs libnetfilter_conntrack libmnl").chomp.split
    system ENV.cc, pkgshare/"examples/nfct-mnl-get.c", *pkg_config_flags, "-o", "nfct-mnl-get"
    assert_match "mnl_socket_recvfrom: Operation not permitted", shell_output("#{testpath}/nfct-mnl-get inet 2>&1", 1)
  end
end
