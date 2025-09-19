class Flvstreamer < Formula
  desc "Stream audio and video from flash & RTMP Servers"
  homepage "https://www.nongnu.org/flvstreamer/"
  url "https://download.savannah.gnu.org/releases/flvstreamer/source/flvstreamer-2.1c1.tar.gz"
  sha256 "e90e24e13a48c57b1be01e41c9a7ec41f59953cdb862b50cf3e667429394d1ee"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c55b7127c5b5b17a88d10808cd4056b2a1ceb2e8fa8a5477c6bc4318a3c43207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dcbbbb87db99f0140c73453fd12af2023b37d44c42302d99156335b0cd69891d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "116c69614242e07bfb2be2d34177335c12a19ef86c8ab5a70e2b3157695f3368"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3de5f4ef4be5bd145b783b309b8be860215f308abbd3134d6def0734861ae63d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c96f83be0a0a72e6172cd9d1459d268cd58c16c930bf2a5c5e60de50654faef3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12ad45a6edb6af98a60963e3a5f302ca40055290233228adf54ae4cd9e491094"
    sha256 cellar: :any_skip_relocation, sonoma:         "016796f39fde0ae13c2757cd29dab5a63c5d8f2dc83004d6d525aab5c824383e"
    sha256 cellar: :any_skip_relocation, ventura:        "b80c82043109dae0ab1868a5f3fadd6897663f55cea6321b6a76364bd91ea5bb"
    sha256 cellar: :any_skip_relocation, monterey:       "ce990e2bc2f6fe933e3203b6a62e0a7f42c899a29a4b77f453ba9ee93b82f8b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b148a052d107098db010c7f1884784dacba4f2f27e7ca9d50c9e3347096a4aa3"
    sha256 cellar: :any_skip_relocation, catalina:       "cfc6a5308ead52bccf753068f8de3a57abd47cf4bdf12d046ca540f3b38ebf8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3a0a12cb4beb91c6bf0ba4f3a5c35a77fe77846ddde1aa9f38dbe1208ed18859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99df5a533003260eea6277d1fa2bb80d0354b666a6a99195c46813e3313c701f"
  end

  # adobe flash player EOL 12/31/2020, https://www.adobe.com/products/flashplayer/end-of-life-alternative.html
  deprecate! date: "2025-03-21", because: :unmaintained

  conflicts_with "rtmpdump", because: "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

  def install
    system "make", "posix"
    bin.install "flvstreamer", "rtmpsrv", "rtmpsuck", "streams"
  end

  test do
    system bin/"flvstreamer", "-h"
  end
end
