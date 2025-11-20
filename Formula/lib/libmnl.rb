class Libmnl < Formula
  desc "Minimalistic user-space library oriented to Netlink developers"
  homepage "https://www.netfilter.org/projects/libmnl"
  url "https://www.netfilter.org/projects/libmnl/files/libmnl-1.0.5.tar.bz2"
  sha256 "274b9b919ef3152bfb3da3a13c950dd60d6e2bcd54230ffeca298d03b40d0525"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/libmnl/downloads.html"
    regex(/href=.*?libmnl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a2f88b9fc807bcdbc77da6579b9937d9c993a637187f1b98c85b82ef6d2f5c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7dc8eaa75b820802be23b7ba7a95e3fe7b4788b0ec8f2d1f1f8180dea1a7daa4"
  end

  depends_on :linux

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <unistd.h>
      #include <time.h>

      #include <libmnl/libmnl.h>
      #include <linux/netlink.h>

      int main(int argc, char *argv[])
      {
        struct mnl_socket *nl;
        char buf[MNL_SOCKET_BUFFER_SIZE];
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmnl", "-o", "test"
  end
end
