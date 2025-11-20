class Pmix < Formula
  desc "Process Management Interface for HPC environments"
  homepage "https://openpmix.github.io/"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/openpmix/openpmix/releases/download/v5.0.9/pmix-5.0.9.tar.bz2"
    sha256 "38d0667636e35a092e61f97be2dd84481f4cf566bfca11bb73c6b3d5da993b7a"

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
    sha256 arm64_tahoe:   "0e5f353dd812019287f31b381c551b9a3f77772ab712ab1607b930a2c3a52f84"
    sha256 arm64_sequoia: "1ee7ba6f1b0345697fb712c5ad5bc85135675dc4d6b61bca1b11cbcc401aea4f"
    sha256 arm64_sonoma:  "9ab0329a6e1145d5ef30f62a00682cd62f9d1b08de40a7a5038dbbee9070b324"
    sha256 arm64_ventura: "7a317bc1c072c4d5abd971b5b85e349bef1e65b1bd772ab6979766caff48b71b"
    sha256 sonoma:        "43155c48adbf01dd0511b9f8ee7cc9ab22509963db829b79a66b2ec83124ffbd"
    sha256 ventura:       "b4256c6ba6136854eb0ddec59de740194fec67df3e25897bde079a3f5189919b"
    sha256 arm64_linux:   "cfceca59052a3e27623b35fb040b679afdf45aebf4ead3b0fe3747a6970b5ec2"
    sha256 x86_64_linux:  "72df17f01735c1d20071ae2e35b4314019a2c76aa56d8931bef599272aecf1c4"
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
