class Pmix < Formula
  desc "Process Management Interface for HPC environments"
  homepage "https://openpmix.github.io/"
  url "https://github.com/openpmix/openpmix/releases/download/v5.0.2/pmix-5.0.2.tar.bz2"
  sha256 "28227ff2ba925da2c3fece44502f23a91446017de0f5a58f5cea9370c514b83c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "2dc990ad5186e8c4862c62ee7e608f1a6cc0efb2b65080d97e9629c64b9dc11f"
    sha256 arm64_ventura:  "a8f7e304d47d9d3cfa02893480b94ae80c9cce20ceca648b4946ded1d6d0e36d"
    sha256 arm64_monterey: "a2d0549998bf47af4592a51563240cb06ba882318dc449cbd2a361ef1cbf01a8"
    sha256 sonoma:         "2d3301431e4c101ce76625edea5b8fee8a2a89abf626c35bd6e769e65928dfe9"
    sha256 ventura:        "183c12a0193eee36482d028d91c4a64963413fd9759fa56aaba5df0724559944"
    sha256 monterey:       "fd39d861d9eef8d64cc5df48b0c2c85dc04161b018ee4d9346d43b4844bfbac3"
    sha256 x86_64_linux:   "7d36f1e06255bbc3f783a35d70c12dd0244102dbe3bb9682aec76a2d029fe734"
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
