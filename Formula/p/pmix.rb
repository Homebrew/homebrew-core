class Pmix < Formula
  desc "Process Management Interface for HPC environments"
  homepage "https://openpmix.github.io/"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/openpmix/openpmix/releases/download/v5.0.6/pmix-5.0.6.tar.bz2"
    sha256 "ea51baa0fdee688d54bc9f2c11937671381f00de966233eec6fd88807fb46f83"

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
    sha256 arm64_sequoia: "87d034df133b3907036920b56bf695e12995398c429d43b33190aab7b63458fb"
    sha256 arm64_sonoma:  "419bffb91abc0ab7e774e6c4cd8a10cef590ac7be7b769055a5cde00fd84c97e"
    sha256 arm64_ventura: "f8b40d4e1fb759ddb4e8a4a77c602ba6ffbaf4c7d8f6ff8ef8c1c972feda6769"
    sha256 sonoma:        "5346c6ffb4f6a63210fe911e3d8b7bbcb6523b81a4ffd682cce01924b131acee"
    sha256 ventura:       "98b66984039760a5571856cb75936132471588bc4d11cc22fd7bd1ac963829b4"
    sha256 x86_64_linux:  "eda624ee8c86875ea6d1f59f787c10e088c6a03bab3c2042e96cfbf2df5c2e31"
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
