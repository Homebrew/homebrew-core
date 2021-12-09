class Jimtcl < Formula
  desc "Small footprint implementation of Tcl"
  homepage "http://jim.tcl.tk/index.html"
  url "https://github.com/msteveb/jimtcl/archive/0.81.tar.gz"
  sha256 "ab7eb3680ba0d16f4a9eb1e05b7fcbb7d23438e25185462c55cd032a1954a985"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_monterey: "7731222d5d1fc542b7bcfe89b34b634d58a4748256227aa3ebaf1a486f9cf8f1"
    sha256 arm64_big_sur:  "3c02ff8a877c59cc3ae8f58b5012a58fa34794fe490df3ab27656f3c5655aa31"
    sha256 monterey:       "15ffdd12ec698a5bc33868c21a02abdca859e4326900c6bcdf31250edf108419"
    sha256 big_sur:        "527d9f121dd3f062480b2fef0db374567efa998efda9ece22fadd3cea89a96cc"
    sha256 catalina:       "32f879425f0e363ccf2f0f23e983e1ca9b7408314c4accfe05a4d20cd6c54ea9"
    sha256 x86_64_linux:   "f39bff291903330771406c56f255af5a8d0711cf715ca152d9e10b3994dce13f"
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--full",
                          "--with-ext=readline,rlprompt,sqlite3",
                          "--shared",
                          "--docdir=#{doc}",
                          "--maintainer",
                          "--math",
                          "--ssl",
                          "--utf8"
    system "make"
    system "make", "install"
    pkgshare.install Dir["examples*"]
  end

  test do
    (testpath/"test.tcl").write "puts {Hello world}"
    assert_match "Hello world", shell_output("#{bin}/jimsh test.tcl")
  end
end
