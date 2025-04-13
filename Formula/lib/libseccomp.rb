class Libseccomp < Formula
  desc "Interface to the Linux Kernel's syscall filtering mechanism"
  homepage "https://github.com/seccomp/libseccomp"
  url "https://github.com/seccomp/libseccomp/releases/download/v2.6.0/libseccomp-2.6.0.tar.gz"
  sha256 "83b6085232d1588c379dc9b9cae47bb37407cf262e6e74993c61ba72d2a784dc"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "1ecb12a4236e7e8906c1e5a632ea775dbaaa06afcaf10899d00f25b768d5b40c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "827764369e33cc2ca6ef5961ab87b4005dc023942fe407f1427d775aec63e4d0"
  end

  head do
    url "https://github.com/seccomp/libseccomp.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gperf" => :build
  depends_on :linux

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
