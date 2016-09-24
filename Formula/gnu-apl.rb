class GnuApl < Formula
  desc "GNU implementation of the programming language APL"
  homepage "https://www.gnu.org/software/apl/"
  url "https://ftpmirror.gnu.org/apl/apl-1.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/apl/apl-1.6.tar.gz"
  sha256 "5e0da83048d81fd99330186f65309661f8070de2472851a8e639b3b7f7e7ff14"

  bottle do
    sha256 "cc3944f693826f8d81cbe4218c02f5c2228ee1388acd9243e80a38d700cb0bc5" => :el_capitan
    sha256 "afba303d682ed0f666658e0200b25e2deafb2eb36a16014249efb23ed12893a6" => :yosemite
    sha256 "1714ec1b2b3b31c7d3468c0ee74f6f6c74e1e08c89fff94099020ff8d7c023aa" => :mavericks
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
