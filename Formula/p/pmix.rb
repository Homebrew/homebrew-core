class Pmix < Formula
  desc "Process Management Interface for HPC environments"
  homepage "https://openpmix.github.io/"
  url "https://github.com/openpmix/openpmix/releases/download/v4.2.7/pmix-4.2.7.tar.bz2"
  sha256 "ac9cf58a0bf01bfacd51d342100234f04c740ec14257e4492d1dd0207ff2a917"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "d4df14c911de4cef20c67dc2603a0c7b73363fb90ed79a0b166c6c79040385a9"
    sha256 arm64_ventura:  "311200ed5cb03bae0bb24e81ee674539c2540d676a006f6480b179c1ee400fb6"
    sha256 arm64_monterey: "cebacf4ff0a50b22567ab80f364cd34ec06ebc07790d87cd80c15e0fdddb990c"
    sha256 sonoma:         "1ffa3e4a7c16159e0129abe31df105664c202e4c8e5a6599a2dd05cfc71075c2"
    sha256 ventura:        "a051514a49e0c020960693679387ae228595998cf9c46cd06752c469506fc0b3"
    sha256 monterey:       "dfeda5fd2b6f96917073e347c91804eac41fad3d1182ed1b7257480ca3253e87"
    sha256 x86_64_linux:   "903e382c3cbee1841c503428513841deaed7cdc2bc22d149487b063121f22f4b"
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
