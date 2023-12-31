class Pmix < Formula
  desc "Process Management Interface for HPC environments"
  homepage "https://openpmix.github.io/"
  url "https://github.com/openpmix/openpmix/releases/download/v4.2.8/pmix-4.2.8.tar.bz2"
  sha256 "09b442878e233f3d7f11168e129b32e5c8573c3ab6aaa9f86cf2d59c31a43dc9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "f20b123e03855e606ec1cf6d25182f44813798152662523fcb2537544f204bd6"
    sha256 arm64_ventura:  "590531f9d2b2742039cced621dc41f749e2807f87a626fbad6e0d98d55d7a69a"
    sha256 arm64_monterey: "ca047a216d801e66031ee341de181af499748ec4fc060d26e128a7b56b466400"
    sha256 sonoma:         "5b658d1050383e23a98639bb1726fff09414c96b28d5b55a3e54baaffcf70bad"
    sha256 ventura:        "f4e6c8b0b72d710a0fa8a6350aa4b013eabe5a666e15121c676235233ca07743"
    sha256 monterey:       "fb5b16d926e2463dc8b1aa71d89792508d2df4037652cfd9621cdd17b1cd5eac"
    sha256 x86_64_linux:   "389565b360ae60d93dde74bebcc5d8cc78d4966a9e99322799b92a0dd575ca09"
  end

  head do
    url "https://github.com/openpmix/openpmix.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "hwloc"
  depends_on "libevent"

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  def install
    # Avoid references to the Homebrew shims directory
    cc = OS.linux? ? "gcc" : ENV.cc
    inreplace "src/tools/pmix_info/support.c", "PMIX_CC_ABSOLUTE", "\"#{cc}\""

    args = %W[
      --disable-silent-rules
      --enable-ipv6
      --sysconfdir=#{etc}
      --with-hwloc=#{Formula["hwloc"].opt_prefix}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-sge
    ]

    system "./autogen.pl", "--force" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <pmix.h>

      int main(int argc, char **argv) {
        pmix_value_t *val;
        pmix_proc_t myproc;
        pmix_status_t rc;

        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpmix", "-o", "test"
    system "./test"

    assert_match "PMIX: #{version}", shell_output("#{bin}/pmix_info --pretty-print")
  end
end
