class Pmix < Formula
  desc "Process Management Interface for HPC environments"
  homepage "https://openpmix.github.io/"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/openpmix/openpmix/releases/download/v5.0.7/pmix-5.0.7.tar.bz2"
    sha256 "b9e6ad482fcdcb58c9b9553ae56956b6d7df875d5605b6ecb96adaff16b2b07a"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "4e59d8ac974bb4044d20819bc706546f0be8d4f93d2606fba9955cf7ef5b3e79"
    sha256 arm64_sonoma:  "f0731ca081ab6b01da5a3e54e54077a7d0c5b04a2d5165eeabed09b01214b1cd"
    sha256 arm64_ventura: "209ca81713565515c252c3f636740cccda036dba9e5902c5bd3624289200878c"
    sha256 sonoma:        "15607c8b02a16b286645e8cdb4b7c188c87544ad231970948554d6f0a263a29a"
    sha256 ventura:       "61e16d267ae760ea5cc166389987588e2910adaecc7ff65073493f3b0f637c87"
    sha256 arm64_linux:   "ba68fae2d7b57e731fbafd7ede776f2601459dee2cbfc3f192b9def427436ea0"
    sha256 x86_64_linux:  "758f1be12c3dfd4326933faf54083748a967450d237da5d6186339b5ebed2b4b"
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
