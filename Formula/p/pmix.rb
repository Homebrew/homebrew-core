class Pmix < Formula
  desc "Process Management Interface for HPC environments"
  homepage "https://openpmix.github.io/"
  license "BSD-3-Clause"
  compatibility_version 1

  stable do
    url "https://github.com/openpmix/openpmix/releases/download/v5.0.11/pmix-5.0.11.tar.bz2"
    sha256 "e10baa9821882140ebd134051702d65b1561fe91954d3978f7ea2c4e4cd36e7f"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      file "Patches/libtool/configure-big_sur.diff"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "70437341b2dd71465c623f30387e7a0f8710cb7d03416d37474f7023b67988b8"
    sha256 arm64_sequoia: "2be2092875cfec5cbc1f7dbc677dcf345a8e1384647935ba2348a1255798b40d"
    sha256 arm64_sonoma:  "82c2b66c2946743d826b683aa940d84da4c2e4536628df6a4054d83bc2671484"
    sha256 sonoma:        "9129e22f8a7c833bf6828de9be914873dec882e083dc687a720643f5400e5be0"
    sha256 arm64_linux:   "c867fa6d4de26b912c83996d9f074cb0b37b5b1ad6cc8f6125fa360c163dea82"
    sha256 x86_64_linux:  "b6dd1be7b922b1974db230cfd94bc451a88a9f711661eaa60eaa6a731ccad0fa"
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
      --with-hwloc=#{formula_opt_prefix("hwloc")}
      --with-libevent=#{formula_opt_prefix("libevent")}
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
