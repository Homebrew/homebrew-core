class Libnfnetlink < Formula
  desc "Low-level library for netfilter related communication"
  homepage "https://www.netfilter.org/projects/libnfnetlink"
  url "https://www.netfilter.org/projects/libnfnetlink/files/libnfnetlink-1.0.1.tar.bz2"
  sha256 "f270e19de9127642d2a11589ef2ec97ef90a649a74f56cf9a96306b04817b51a"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/libnfnetlink/downloads.html"
    regex(/href=.*?libnfnetlink[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4cc0401b5074648aba2b0140000ad7728fafd440f8d100d6c868b6f5a9f524aa"
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
      #include <libnfnetlink/libnfnetlink.h>

      int main() {
        int i = NFNL_BUFFSIZE;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnfnetlink", "-o", "test"
  end
end
