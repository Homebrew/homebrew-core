class Lout < Formula
  desc "Text formatting like TeX, but simpler"
  homepage "https://savannah.nongnu.org/projects/lout"
  url "https://download.savannah.gnu.org/releases/lout/lout-3.40.tar.gz"
  sha256 "3d16f1ce3373ed96419ba57399c2e4d94f88613c2cb4968cb0331ecac3da68bd"
  license "GPL-3.0"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lout/"
    regex(/href=.*?lout[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b5c17e1a84234c943468eac4a3ba86051231fdd72abf8761e9206182f8a3303a"
    sha256 arm64_big_sur:  "3164a9e3f8d721f43d2596518c15493ee8d0ab9817f799c2cbcb72f9ca3e5a67"
    sha256 monterey:       "df5fe36cb680e0575d183d0d7bf6c94e17e74b696507fbb70839d0607d839812"
    sha256 big_sur:        "744551b3b7479af62015ceb2f54736ea4f4c68f4c87862a0fb0af62c731ed454"
    sha256 catalina:       "67aec968bd2e1957d7b4fe7a2ae201b701ef45dd98c9766ffbc7a0ae3ca1af70"
    sha256 mojave:         "2f69e0d4097fbf53f05855b5eeb2def0efcaf08c3a5b2487b1fa041031c2eacc"
    sha256 high_sierra:    "2de1b1b7526f7427b8a57b6239a5a8c199ee05365ead7ed8d722a9e7e3123a0e"
    sha256 sierra:         "2cfc68ddba21e6f485a4a57df9e810b6996d5364374c66e77b06d41ce230f060"
    sha256 el_capitan:     "2fbc90ffc3f12312dc11e31996ba94da3b8a4ba1c55f33ca60a5d81aef4e137f"
    sha256 yosemite:       "366023d41536d0220a3d226a9f7a5e65b89fcf8ec212bfd6e53f8c2b4110abce"
    sha256 x86_64_linux:   "3b6e15578cc9b6dbe6f4b0ea9e18fce710974e552381b0b61a931577bb6c384f"
  end

  def install
    bin.mkpath
    man1.mkpath
    (doc/"lout").mkpath
    system "make", "PREFIX=#{prefix}", "LOUTLIBDIR=#{lib}", "LOUTDOCDIR=#{doc}", "MANDIR=#{man}", "allinstall"
  end

  test do
    input = "test.lout"
    (testpath/input).write <<~EOS
      @SysInclude { doc }
      @Doc @Text @Begin
      @Display @Heading { Blindtext }
      The quick brown fox jumps over the lazy dog.
      @End @Text
    EOS
    assert_match(/^\s+Blindtext\s+The quick brown fox.*\n+$/, shell_output("#{bin}/lout -p #{input}"))
  end
end
