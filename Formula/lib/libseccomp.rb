class Libseccomp < Formula
  desc "Interface to the Linux Kernel's syscall filtering mechanism"
  homepage "https://github.com/seccomp/libseccomp"
  url "https://github.com/seccomp/libseccomp/releases/download/v2.6.2/libseccomp-2.6.2.tar.gz"
  sha256 "6b845d352c6d7887d8d134c43d86850d40f5dcee11ad1675c18197ae4d869d42"
  license "LGPL-2.1-only"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "dbaf2d3a367780c34ff48bb118274b61c18eb0879b22f4092aa87e016cadf7e9"
    sha256 cellar: :any, arm64_linux:  "c0fcbf64b62f0c2f52d373094a8b995eae04b741c9913e7444a13385a1607ad4"
    sha256 cellar: :any, x86_64_linux: "cfb7331e0f2524d22aeeeacd1832ff2426adc04ccaf2fdc75fff48610da88624"
  end

  head do
    url "https://github.com/seccomp/libseccomp.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gperf" => :build
  depends_on :linux

  deny_network_access!

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    ver_major, ver_minor, = version.to_s.split(".")

    (testpath/"test.c").write <<~C
      #include <seccomp.h>
      int main(int argc, char *argv[])
      {
        if(SCMP_VER_MAJOR != #{ver_major})
          return 1;
        if(SCMP_VER_MINOR != #{ver_minor})
          return 1;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lseccomp", "-o", "test"
    system "./test"
  end
end
