class GnuApl < Formula
  desc "GNU implementation of the programming language APL"
  homepage "https://www.gnu.org/software/apl/"
  url "https://ftp.gnu.org/gnu/apl/apl-1.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/apl/apl-1.7.tar.gz"
  sha256 "8ff6e28256d7a3cdfa9dc6025e3905312310b27a43645ef5d617fd4a5b43b81f"

  bottle do
    rebuild 1
    sha256 "a9eb61a290f98be04bf57a90202a6c86f74e485c0ee5e7c0178d15d254bb1b00" => :mojave
    sha256 "33e8f7db591cfbd0fda5b244acbf13f21e9507a6b534b9cd2735c2dc37f16424" => :high_sierra
    sha256 "1b7b6f3d268ac7f32f1d23e64be979cbf382b728c92c6e852f75b09eb19fddfb" => :sierra
    sha256 "797a920a7f564443b7a7b5c5ee065e6d6da25e2395c87dc6f1846adc3dedd109" => :el_capitan
  end

  head do
    url "https://svn.savannah.gnu.org/svn/apl/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :macos => :mavericks
  # GNU Readline is required; libedit won't work.
  depends_on "readline"
  depends_on "libpq" => :optional

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

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
