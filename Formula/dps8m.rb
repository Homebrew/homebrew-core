class Dps8m < Formula
  desc "Simulator of the 36‑bit GE/Honeywell/Bull 600/6000‑series mainframe computers"
  homepage "https://dps8m.gitlab.io/"
  url "https://dps8m.gitlab.io/dps8m-archive/R3.0.0/dps8m-r3.0.0-src.tar.gz"
  sha256 "e3eac9e4f8b6c7fad498ff1848ba722e1a2e220b793ce02e2ea6a7a585e0c91f"
  license "ICU"
  revision 1
  head "https://gitlab.com/dps8m/dps8m.git", branch: "master"

  livecheck do
    url "https://dps8m.gitlab.io/dps8m/Releases/"
    regex(/href=.*?dps8m[._-]r?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ba27cf723d5702593457efb495c769f2846b4bd3a6878ac79f92c0eca54da8f9"
    sha256 cellar: :any,                 arm64_monterey: "efbf793085471011b68d7203e5a6a10a2ac9bfd2f9ea8b12a6e1f464a825b5ac"
    sha256 cellar: :any,                 arm64_big_sur:  "b898cb7a4f4bd2d32cfdaa53c2792e3243fca88a316782605dc6b0ec75f379b8"
    sha256 cellar: :any,                 ventura:        "3b2b3258518e5757a97a7270f1fba79fdd2380117326b25d913d7a857318a446"
    sha256 cellar: :any,                 monterey:       "128e289f09358b7fc7913772787d2cd3a266d789e0f7f95d059e32f9a3984ff8"
    sha256 cellar: :any,                 big_sur:        "a9e0b7f6aca5cc731c7f83126232510f70431839b3d5865f1bf97f19ea0f68bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d29e9bdb2a3f19ac2010e8f0f1aaa9768a0c8c1d4cac5133549b0ca090a84a"
  end

  depends_on "libuv"

  uses_from_macos "expect" => :test

  def install
    # Reported 23 Jul 2017 "make doesn't create bin directory"
    # See https://sourceforge.net/p/dps8m/mailman/message/35960505/
    bin.mkpath

    system "make"
    bin.install %w[src/dps8/dps8 src/punutil/punutil src/prt2pdf/prt2pdf]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/dps8 -t
      set timeout 30
      expect {
        timeout { exit 1 }
        ">"
      }
      set timeout 10
      send "SH VE\r"
      expect {
        timeout { exit 2 }
        "Version:"
      }
      send "q\r"
      expect {
        timeout { exit 3 }
        eof
      }
    EOS
    system("expect", "-f", "test.exp")
  end
end
