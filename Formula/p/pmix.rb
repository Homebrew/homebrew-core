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
    sha256 arm64_sonoma:   "7534c07deb72ae5959aacf9ed49de22302cb043cee37ee828adf005b4c2021e0"
    sha256 arm64_ventura:  "cbe3c310a455283c40f9cd387661ae2310e62acca9dc106eb836c6caaf37dbaf"
    sha256 arm64_monterey: "008391906fc8577402975247333c6be1c5626b98501606e1eb99fed34fb5f628"
    sha256 sonoma:         "61e063ae000d60e98c508a5a0adb3244395422363642956911194ee88b3c97e7"
    sha256 ventura:        "fe4acd1ae9fbf99199d721dddb66099fba02479381a590da220aef729237ed64"
    sha256 monterey:       "9c214c1379e3fe27e390f1b8c2d5e2b52cc5f979106e267929cb9b11fbeb5cf2"
    sha256 x86_64_linux:   "aae3cda6ed8e0af8918a7b63346b47528979093f6899a6333297c92cb184d9d0"
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
