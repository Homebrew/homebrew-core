class Libmnl < Formula
  desc "Minimalistic user-space library oriented to Netlink developers"
  homepage "https://www.netfilter.org/projects/libmnl"
  url "https://www.netfilter.org/projects/libmnl/files/libmnl-1.0.4.tar.bz2"
  sha256 "171f89699f286a5854b72b91d06e8f8e3683064c5901fb09d954a9ab6f551f81"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/libmnl/downloads.html"
    regex(/href=.*?libmnl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1ece867c29037eab669864263d1c09e53a590f105916b86bcd9673c279eb6462"
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
    (testpath/"test.c").write <<~EOS
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
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmnl", "-o", "test"
  end
end
