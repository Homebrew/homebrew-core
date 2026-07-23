class Prrte < Formula
  desc "PMIx Reference RunTime Environment"
  homepage "https://pmix.org/"
  license "BSD-3-Clause-Open-MPI"
  revision 1

  stable do
    url "https://github.com/openpmix/prrte/releases/download/v4.1.0/prrte-4.1.0.tar.bz2"
    sha256 "285ad62b670075708b9fcfe14c54baa599733bc274d10502a82e8eebba0b7c70"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      file "Patches/libtool/configure-big_sur.diff"
      type :unofficial
    end

    # Fix segmentation fault for some Apple Silicon
    patch do
      url "https://github.com/openpmix/prrte/commit/378c61c1d8eff9858a7774c869fbd332c48711a8.patch?full_index=1"
      sha256 "64faa1acb89eddea096307a2658b11ccdaf85dc8c870fed4b3f8670329706a4f"
      type :backport
      resolves "https://github.com/openpmix/prrte/issues/2416"
    end
  end

  bottle do
    sha256 arm64_tahoe:   "e113e688a868463e07a94372a25df0b23193286c74ed58349896b45e4dd4b0c1"
    sha256 arm64_sequoia: "83ad171eccc7a0fac0b76ce4d3b19da1126a43358fdbf9c46a5bfbd4c29d7f18"
    sha256 arm64_sonoma:  "c6035fc5594ea0c5d26267bcd33af470b4b251a644099175dedfb9a21f57a5c4"
    sha256 sonoma:        "9b40f42ccaa94b22978a490c057b296a0018364bd2c833acabbee32c130aad6f"
    sha256 arm64_linux:   "e19030480fad25fbb5121640c98e813a614ac98fd4a8efc950a8a6b6d0a5ff57"
    sha256 x86_64_linux:  "afe5f770308210f0b18965301e0dfe493b7af1e8363e51429d30af1984e3bdfd"
  end

  head do
    url "https://github.com/openpmix/prrte.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    uses_from_macos "flex" => :build
    uses_from_macos "python" => :build
  end

  depends_on "hwloc"
  depends_on "libevent"
  depends_on "pmix"

  uses_from_macos "perl" => :build

  # These used to be bundled with open-mpi
  link_overwrite "bin/pcc", "bin/prte*", "bin/prun", "include/prte*", "lib/libprrte.*"
  link_overwrite "share/man/man1/prte*.1", "share/man/man1/prun.1",
                 "share/man/man5/prte.5", "share/doc/prrte/", "share/prte/"

  def install
    # Avoid references to the Homebrew shims directory
    inreplace "src/tools/prte_info/prte_info.c", "PRTE_CC_ABSOLUTE", "\"#{ENV.cc}\""

    args = %W[
      --disable-silent-rules
      --enable-ipv6
      --sysconfdir=#{etc}
      --with-hwloc=#{formula_opt_prefix("hwloc")}
      --with-libevent=#{formula_opt_prefix("libevent")}
      --with-pmix=#{formula_opt_prefix("pmix")}
      --with-sge
      --without-legacy-tools
    ]

    system "./autogen.pl", "--force" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # Based on https://github.com/openpmix/prrte/blob/master/test/attachtest/app.c
    (testpath/"test.c").write <<~'C'
      #include <pmix.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main(int argc, char **argv)
      {
        int pause = 0;
        if (argc > 1) {
            pause = atoi(argv[1]);
        }

        pmix_proc_t proc;
        pmix_status_t rc = PMIX_ERROR;

        rc = PMIx_Init(&proc, NULL, 0);
        if (rc != PMIX_SUCCESS) {
          fprintf(stderr, "PMIx_Init failed: %s\n", PMIx_Error_string(rc));
          return EXIT_FAILURE;
        }

        printf("Hello\n");

        sleep(pause);

        printf("Bye\n");

        rc = PMIx_Finalize(NULL, 0);
        if (rc != PMIX_SUCCESS) {
          fprintf(stderr, "PMIx_Finalize failed: %s\n", PMIx_Error_string(rc));
          return EXIT_FAILURE;
        }
        return EXIT_SUCCESS;
      }
    C

    system bin/"pcc", "test.c", "-o", "test"
    assert_equal "Hello\nHello\nBye\nBye\n", shell_output("#{bin}/prterun -n 2 ./test 1")

    assert_match version.to_s, shell_output("#{bin}/prte-info")
  end
end
