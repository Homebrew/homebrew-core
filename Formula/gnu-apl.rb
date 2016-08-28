class GnuApl < Formula
  desc "GNU implementation of the programming language APL"
  homepage "https://www.gnu.org/software/apl/"
  url "https://ftpmirror.gnu.org/apl/apl-1.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/apl/apl-1.6.tar.gz"
  sha256 "5e0da83048d81fd99330186f65309661f8070de2472851a8e639b3b7f7e7ff14"

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
    # Fix "LApack.cc:21:10: fatal error: 'malloc.h' file not found"
    inreplace "src/LApack.cc", "malloc.h", "malloc/malloc.h"

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
      assert_match "Hello world", shell_output("#{bin}/apl -s -f hello.apl")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
