class Ipsumdump < Formula
  desc "Summarizes TCP/IP dump files into a self-describing ASCII format"
  homepage "https://read.seas.harvard.edu/~kohler/ipsumdump/"
  url "https://read.seas.harvard.edu/~kohler/ipsumdump/ipsumdump-1.86.tar.gz"
  sha256 "e114cd01b04238b42cd1d0dc6cfb8086a6b0a50672a866f3d0d1888d565e3b9c"
  license "MIT"
  head "https://github.com/kohler/ipsumdump.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ipsumdump[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "4b887c63e1aec769b9142c42cc8e5ddbb8020ab232604111f635c06e4a61ba6d"
    sha256 arm64_sequoia:  "df39ad78cb2e3dbca54558205978fc4c39ffee8b17f11027f51c62dab42b9da7"
    sha256 arm64_sonoma:   "009a39b4f09dc2d72956618d85b8981ec8288b7320a4072799b670b72c863680"
    sha256 arm64_ventura:  "e6643af43d1106c2e50a60b58d80997e52623dcfeab558f26e0045ba16a74ecc"
    sha256 arm64_monterey: "1494705fff0bb7937d74557efd7484896a8c87133dad9a4e40ee2ee5b5da67eb"
    sha256 arm64_big_sur:  "6348649ec33f562a3622f97fb7b253d39ed8b3f919a9aa2af8fa84b8d67d765a"
    sha256 sonoma:         "ed6f33b6662a53b8f5fa73dbceff2a2ecafdc517dbc986ad6e091cf74201d2c9"
    sha256 ventura:        "3b5c4c6d9645971bdb31dbaf9e2fa6feae366d34bf2c1d6720af1d8cd77a9062"
    sha256 monterey:       "421b6575ab2ea358e7dadb1d43f2519efb2e8f8353260c3e2b83e7d4610d3841"
    sha256 big_sur:        "f3302bce45a3eed980b7c07d05eabc9088a469cd07528c5e1f32a52474b6383a"
    sha256 catalina:       "bf3d17d0d8bd97b75c44fd7929e348e096f3f1ac6a94ff31e785eb1f685db041"
    sha256 arm64_linux:    "64cca494a61a1849068d908106a059039b47fe6bae0504056995c2af2f43e2fd"
    sha256 x86_64_linux:   "27e438253bf0b215381e8f27d3898eab9e905181266347997c5f59cfdc46175a"
  end

  # add missing definition for SIOCGSTAMP to support linux arm build
  patch :DATA

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ipsumdump -c -r #{test_fixtures("test.pcap")}")
    assert_match "!host #{Socket.gethostname}", output
    assert_match "!data count\n" + ("1\n" * 12), output
  end
end

__END__
diff --git a/src/fromdevice.cc b/src/fromdevice.cc
index 76e2b12..f59d7bd 100644
--- a/src/fromdevice.cc
+++ b/src/fromdevice.cc
@@ -28,6 +28,11 @@
 #else
 # include <sys/ioccom.h>
 #endif
+
+#ifndef SIOCGSTAMP
+#define SIOCGSTAMP 0x8906
+#endif
+
 #if HAVE_NET_BPF_H
 # include <net/bpf.h>
 # define PCAP_DONT_INCLUDE_PCAP_BPF_H 1
