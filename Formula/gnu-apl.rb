class GnuApl < Formula
  desc "GNU implementation of the programming language APL"
  homepage "https://www.gnu.org/software/apl/"

  stable do
    url "https://ftpmirror.gnu.org/apl/apl-1.5.tar.gz"
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
    sha256 "fd46b7642d9bf9012dd2d8dc745131be3e1e49744892c17144bc2a1e90f81134" => :el_capitan
    sha256 "d05a338bb83638d10d55880310ab62fb5ba2b8265fb52b87839ac7af26058128" => :yosemite
    sha256 "c6b72b03650f7477351e66b1bed497eea6ba4a439dd131fd48cb903532e16d04" => :mavericks
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
