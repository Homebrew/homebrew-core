class GnuApl < Formula
  desc "GNU implementation of the programming language APL"
  homepage "https://www.gnu.org/software/apl/"
  url "https://ftpmirror.gnu.org/apl/apl-1.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/apl/apl-1.7.tar.gz"
  sha256 "8ff6e28256d7a3cdfa9dc6025e3905312310b27a43645ef5d617fd4a5b43b81f"

  bottle do
    sha256 "ba1839e1a64c434180af2b8ba81c43e35cacd685eed11fcbeaeced5c5e58b87f" => :sierra
    sha256 "1077298d934bc67c86d8196405f7ff312e52631ed3489bb868cf7d23196a6bf9" => :el_capitan
    sha256 "235adcfc3ec604544b0c18cd61b6b4f1b9bbe47f1415e6b94e13f9a7d9264115" => :yosemite
  end

  head do
    url "https://svn.savannah.gnu.org/svn/apl/trunk"

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
      assert_match "Hello world", shell_output("#{bin}/apl -s -f hello.apl")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
