class Libseccomp < Formula
  desc "Interface to the Linux Kernel's syscall filtering mechanism"
  homepage "https://github.com/seccomp/libseccomp"
  url "https://github.com/seccomp/libseccomp/releases/download/v2.5.1/libseccomp-2.5.1.tar.gz"
  sha256 "ee307e383c77aa7995abc5ada544d51c9723ae399768a97667d4cdb3c3a30d55"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gperf" => :build
  depends_on "libtool" => :build
  depends_on :linux

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ver_major, ver_minor, = version.to_s.split(".")

    (testpath/"test.c").write <<~EOS
      #include <seccomp.h>
      int main(int argc, char *argv[])
      {
        if(SCMP_VER_MAJOR != #{ver_major})
          return 1;
        if(SCMP_VER_MINOR != #{ver_minor})
          return 1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lseccomp", "-o", "test"
    system "./test"
  end
end
