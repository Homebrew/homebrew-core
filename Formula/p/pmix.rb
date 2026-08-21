class Pmix < Formula
  desc "Process Management Interface for HPC environments"
  homepage "https://openpmix.org/"
  license "BSD-3-Clause-Open-MPI"
  compatibility_version 1

  stable do
    url "https://github.com/openpmix/openpmix/releases/download/v6.1.0/pmix-6.1.0.tar.bz2"
    sha256 "bb9021c8e100a376f5070ecca727f83a29b5f652dfe381793b88daa79a3b98a2"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      file "Patches/libtool/configure-big_sur.diff"
      type :unofficial
    end
  end

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "e92ef10e3a830c714f77e437c8c0bc95a74e4e271c11a227bec04751f9e39e1e"
    sha256 arm64_sequoia: "84f5dc1c87771751b12ffc20d210ecdb0ffce10417adb4698046233d895a5cb9"
    sha256 arm64_sonoma:  "4ebae743971057aedb4bcb9e0c3184dcdf928810a07ca6b9aaf8e392d1040b3b"
    sha256 sonoma:        "ffea6a8f88516bae345bbb60d0de547a77b21188a84d4389f82df7a90eba7507"
    sha256 arm64_linux:   "c4d370ae2ff7a7600464f51fee127331073d4aaf1c284705ec04ecb00ff2d109"
    sha256 x86_64_linux:  "d27aea1dc4807880a160e08f03a2b0a4210e7d731d6be8e702d04501334b2b05"
  end

  head do
    url "https://github.com/openpmix/openpmix.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    uses_from_macos "flex" => :build
    uses_from_macos "python" => :build
  end

  depends_on "hwloc"
  depends_on "libevent"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Avoid references to the Homebrew shims directory
    inreplace "src/runtime/pmix_info_support.c", "PMIX_CC_ABSOLUTE", "\"#{ENV.cc}\""

    args = %W[
      --disable-silent-rules
      --enable-ipv6
      --sysconfdir=#{etc}
      --with-hwloc=#{formula_opt_prefix("hwloc")}
      --with-libevent=#{formula_opt_prefix("libevent")}
      --with-sge
    ]

    system "./autogen.pl", "--force" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # Based on https://github.com/openpmix/openpmix/blob/master/examples/simple.c
    (testpath/"test.c").write <<~'C'
      #include <stdio.h>
      #include <stdlib.h>
      #include <pmix.h>

      static pmix_proc_t myproc;

      int main(void) {
        pmix_status_t rc;

        if (PMIX_SUCCESS != (rc = PMIx_Init(&myproc, NULL, 0))) {
          if (PMIX_ERR_UNREACH != rc) {
            fprintf(stderr, "Client ns %s rank %d: PMIx_Init failed: %s\n", myproc.nspace, myproc.rank,
                    PMIx_Error_string(rc));
            return 1;
          }
        }

        rc = PMIx_Finalize(NULL, 0);
        if (PMIX_SUCCESS != rc) {
          fprintf(stderr, "Finalize failed: %s\n", PMIx_Error_string(rc));
        }

        fflush(stderr);
        return rc;
      }
    C

    system bin/"pmixcc", "test.c", "-o", "test"
    system "./test"

    assert_match version.to_s, shell_output("#{bin}/pmix_info --pretty-print")
  end
end
