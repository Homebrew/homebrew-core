class GnuApl < Formula
  desc "GNU implementation of the programming language APL"
  homepage "https://www.gnu.org/software/apl/"
  license "GPL-3.0"

  stable do
    url "https://ftp.gnu.org/gnu/apl/apl-1.8.tar.gz"
    mirror "https://ftpmirror.gnu.org/apl/apl-1.8.tar.gz"
    sha256 "144f4c858a0d430ce8f28be90a35920dd8e0951e56976cb80b55053fa0d8bbcb"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  bottle do
    sha256 arm64_monterey: "b7b9eef4cbb52a83000246627a0160dd39852969d1cdd98f29442e24611d97c8"
    sha256 arm64_big_sur:  "d5c8031c3c878eadcc74fb5353e54ff8413c51a8c62bc89a51e21542a77bf3a6"
    sha256 monterey:       "bcdc76b18f964c04e738aeffc16850029324b40ca9aaad03cbed554be431635c"
    sha256 big_sur:        "e8da710fdd9108e7fd6d11adf6b67f8e11bf6e7b027c09a6e334b1a68b258da0"
    sha256 catalina:       "2a7717b6b60567eade10b30f473771f563ebd6a009c91e0522eab6497516e892"
    sha256 mojave:         "9df4d2bfcfda74e10451b132d0c274265bb1e550a9d7829402913d7798a83c46"
    sha256 high_sierra:    "d1d035cef7cb23ecde90146a8eae564fbbeba3546228618dc250581d5611a4ab"
    sha256 sierra:         "cbb8043b314e3141b2a9e6e3121b7c797ca68298374d9c50f6d07447e5ea7ca5"
    sha256 x86_64_linux:   "cbf69e533bf5625cf34375113fb2e3ff339d4e8d52fb550e84010eb87b1a7919"
  end

  head do
    url "https://svn.savannah.gnu.org/svn/apl/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "readline" # GNU Readline is required, libedit won't work

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900
    ENV.delete("HOMEBREW_SDKROOT") if MacOS.version == :high_sierra

    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.apl").write <<~EOS
      'Hello world'
      )OFF
    EOS

    pid = fork do
      exec "#{bin}/APserver"
    end
    sleep 4

    begin
      assert_match "Hello world", shell_output("#{bin}/apl -s -f hello.apl")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
