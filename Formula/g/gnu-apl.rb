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
    rebuild 1
    sha256 arm64_ventura:  "77a4cb83c7800623533fd94943f01c0e5bd2b8eeaf52255f8839227db9e47ecb"
    sha256 arm64_monterey: "620de4f5d76edf28962b64cca150e9607a4fa663cc0f9fcf0b9ebaa43eb1c8b1"
    sha256 arm64_big_sur:  "70eb998b36d113e576e114caf29b8b3ed46da86b05d34979f03adb6f2daca772"
    sha256 ventura:        "64675318c4788ea65d43c4309da414879fc55142b1bfb8bf01e04f423b87dc8f"
    sha256 monterey:       "3a606c0983eed237b401953d9e871fb69a76aee5b4d26d07a859b51b6451c6de"
    sha256 big_sur:        "995c4010d02d4af05d2d7772a5957028e6f9860864370807588e306dd3b0dc27"
    sha256 catalina:       "76ef781d65c2704150aa2435dee2346badb666fe5dfebcc35cd646673246d1b2"
    sha256 x86_64_linux:   "d586350548ba42b1d7b56d131d9d21cc23313ad4eaa396af8f027ca37beb8db4"
  end

  head do
    url "https://svn.savannah.gnu.org/svn/apl/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "readline" # GNU Readline is required, libedit won't work

  def install
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
