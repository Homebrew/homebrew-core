class Pmix < Formula
  desc "Process Management Interface for HPC environments"
  homepage "https://openpmix.github.io/"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/openpmix/openpmix/releases/download/v5.0.8/pmix-5.0.8.tar.bz2"
    sha256 "bf5f0a341d0ec7f465627a7570f4dcda3b931bc859256428a35f6c72f13462d0"

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
    sha256 arm64_sequoia: "a7d99c8e194b5a0191094bf5c301466aecf2cdddc4a30f82f49fe72eb8b61373"
    sha256 arm64_sonoma:  "d52b37238c114a79dc57612d0fb2217bdd6f37ac81a3c3836121377c341677b0"
    sha256 arm64_ventura: "6151bd4898bad61e4f9a58ba50f8b10f3c211c71c1907bfd70c6721ce7e6bba7"
    sha256 sonoma:        "8eb6695bd7001e3d7dc6cc0a404e14592d5bb69ec9e29cebfa21d95972199896"
    sha256 ventura:       "fdeaf1f3920bb26ac0d4242ca443f5b07af478b6e7fb8b2de33b4d972401387e"
    sha256 arm64_linux:   "be81426a4e1b74b7c6cfd8b62eb05407731580fe470ffd0c7a10cda31491d091"
    sha256 x86_64_linux:  "3a4abb4032f58acdc7b067183ed6a8a8199e4482d72a9e5c536a079722c98f58"
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
