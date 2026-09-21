class Libseccomp < Formula
  desc "Interface to the Linux Kernel's syscall filtering mechanism"
  homepage "https://github.com/seccomp/libseccomp"
  url "https://github.com/seccomp/libseccomp/releases/download/v2.6.1/libseccomp-2.6.1.tar.gz"
  sha256 "501f66c667225d53791b97e1d7cf85ab764c297d04881f60f38f451c4b0ee1be"
  license "LGPL-2.1-only"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "dfa3d0c4946724af90e4f7739c42730b3c257d540a140ca0cdb4982511513931"
    sha256 cellar: :any, x86_64_linux: "9e72c2ef0f0d1a4081ede5f46a0c6fe2a6b7060ae4b2552736f70a3060f4cdbb"
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
