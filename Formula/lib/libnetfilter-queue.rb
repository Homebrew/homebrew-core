class LibnetfilterQueue < Formula
  desc "Userspace API to packets queued by the kernel packet filter"
  homepage "https://www.netfilter.org/projects/libnetfilter_queue"
  url "https://www.netfilter.org/projects/libnetfilter_queue/files/libnetfilter_queue-1.0.5.tar.bz2"
  sha256 "f9ff3c11305d6e03d81405957bdc11aea18e0d315c3e3f48da53a24ba251b9f5"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/libnetfilter_queue/downloads.html"
    regex(/href=.*?libnetfilter_queue[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "0d88b35944420ead47b296ddc1e8a374591138b640c4aeede86e02b0104de7c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "92a395a74268dd17a019cf43ca0a5bbe38ad52e045697e403657abc3250e3f6e"
  end

  depends_on "pkgconf" => :build
  depends_on "libmnl"
  depends_on "libnfnetlink"
  depends_on :linux

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <errno.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <unistd.h>
      #include <string.h>
      #include <time.h>
      #include <arpa/inet.h>

      #include <libmnl/libmnl.h>
      #include <linux/netfilter.h>
      #include <linux/netfilter/nfnetlink.h>

      #include <linux/types.h>
      #include <linux/netfilter/nfnetlink_queue.h>

      #include <libnetfilter_queue/libnetfilter_queue.h>

      int main(int argc, char *argv[])
      {
        struct mnl_socket *nl;
        char buf[NFQA_CFG_F_MAX];
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmnl", "-o", "test"
  end
end
