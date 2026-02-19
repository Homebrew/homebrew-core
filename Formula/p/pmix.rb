class Pmix < Formula
  desc "Process Management Interface for HPC environments"
  homepage "https://openpmix.github.io/"
  license "BSD-3-Clause"
  revision 1

  stable do
    url "https://github.com/openpmix/openpmix/releases/download/v5.0.10/pmix-5.0.10.tar.bz2"
    sha256 "78663f6b932589d68e24feaf7f8a948d60be68d91965f3effbacb4cd88cf9a95"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "5ae502e52b0701368cd61fd43b12f67df1c074bd2a6027bf5f1cbe1ef213817d"
    sha256 arm64_sequoia: "2f1d03fa49fb8731e9e60c03b25670bfe10acbaeeafc20de491eab57bda31c26"
    sha256 arm64_sonoma:  "6ff719706c1ace854d29922ddbe65a62a64f4f6f356b3af44d6eadcb7511e39e"
    sha256 sonoma:        "d93205b42ae1181cbfd0b84ee6fe6697cb60f8c6472cfffddc16c6af10f4a174"
    sha256 arm64_linux:   "d5c71a20e25fd1ad9d512dd40c882eef16c980a387a601e2617195913175c2b1"
    sha256 x86_64_linux:  "93fd3b3e99b624b63f07fb8580d22684387aaacbcf8c3bf9a89536253b32ce09"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <pmix.h>

      int main(int argc, char **argv) {
        pmix_value_t *val;
        pmix_proc_t myproc;
        pmix_status_t rc;

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpmix", "-o", "test"
    system "./test"

    assert_match "PMIX: #{version}", shell_output("#{bin}/pmix_info --pretty-print")
  end
end
