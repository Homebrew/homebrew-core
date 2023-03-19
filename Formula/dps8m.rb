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
    sha256 cellar: :any,                 arm64_ventura:  "da7b5be87b8f69e613145c28839ed308547823dfdb49ec6b1ab2b7e460217b6a"
    sha256 cellar: :any,                 arm64_monterey: "c3a543790a54d7c89b2406543d12031d65358b0a6d628dab3e2e91fab93c8738"
    sha256 cellar: :any,                 arm64_big_sur:  "fb6d8befa480a17d4cf80f6389a2f06d6005304098120e8e79b158589860cc51"
    sha256 cellar: :any,                 ventura:        "c9f01dff1946f16e5f4f20c74939643d764ba65456ab3f62342624e7fc1b59ca"
    sha256 cellar: :any,                 monterey:       "6d003d8c6626ebfbf6a2efe18bfd1f9c2b860eb442372dcb31de0a6040f64f72"
    sha256 cellar: :any,                 big_sur:        "776bf405ac9a2e1d04f4770f4faeb8d7b1ab816cdbf88922b616073a41844301"
    sha256 cellar: :any,                 catalina:       "75ed3b37ef4b1e869adc41e931a0b810312f0634085cf60255a461c8235cb96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "382ab8f05a7161e6895075d7e263a8324e507415ede94d40cacdf47f324382bb"
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
