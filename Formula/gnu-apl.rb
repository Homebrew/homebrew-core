class GnuApl < Formula
  desc "GNU implementation of the programming language APL"
  homepage "https://www.gnu.org/software/apl/"

  stable do
    url "http://ftpmirror.gnu.org/apl/apl-1.5.tar.gz"
    mirror "https://ftp.gnu.org/gnu/apl/apl-1.5.tar.gz"
    sha256 "013addd15cab829d3212fb787023a723e01f2e58e4836acbedbc2dc7078e8d40"

    # Upstream fixes for clang build failures, the first of which is
    # "non-ASCII characters are not allowed outside of literals and identifiers"
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/69c8268d/gnu-apl/clang-fixes.patch"
      sha256 "1d2c3e6d97f26ea25bc1e0126a4968537e6d54044cf0a991e0477d462c0158bf"
    end
  end

  bottle do
    revision 1
    sha256 "272fc906d7e7889c87e7f2f3a46af194730482c6fc6e8021b06580798694ff91" => :el_capitan
    sha256 "0a061c8ca10b237d15eddd13acf0bc1007b1b18888eda30cd43beeaa77602979" => :yosemite
    sha256 "350db093b3749d355147717f3e3209378c32aae2e508e2b54534f002be5fdedd" => :mavericks
  end

  head do
    url "http://svn.savannah.gnu.org/svn/apl/trunk"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  # GNU Readline is required; libedit won't work.
  depends_on "readline"
  depends_on :macos => :mavericks

  def install
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.apl").write <<-EOS.undent
      'Hello world'
      )OFF
    EOS

    pid = fork do
      exec "#{bin}/APserver"
    end
    sleep 4

    begin
      assert_match /Hello world/, shell_output("#{bin}/apl -s -f hello.apl")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
