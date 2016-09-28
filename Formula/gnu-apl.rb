class GnuApl < Formula
  desc "GNU implementation of the programming language APL"
  homepage "https://www.gnu.org/software/apl/"
  url "https://ftpmirror.gnu.org/apl/apl-1.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/apl/apl-1.6.tar.gz"
  sha256 "5e0da83048d81fd99330186f65309661f8070de2472851a8e639b3b7f7e7ff14"
  revision 1

  bottle do
    sha256 "7c5aebad3061ad6713b08465b6db4534937eabe655f85af52d1d20066811ebdf" => :sierra
    sha256 "25d163f1cf8adac585f914640b6281ef530876a60812864699bf0b349d3a58af" => :el_capitan
    sha256 "6164637b1f3b76040e031c5cb53444d1e48d5a007f5ffcc0270d9ad7d75679be" => :yosemite
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
