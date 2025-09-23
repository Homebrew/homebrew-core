class Mtm < Formula
  desc "Micro terminal multiplexer"
  homepage "https://github.com/deadpixi/mtm"
  url "https://github.com/deadpixi/mtm/archive/refs/tags/1.2.1/1.2.1.tar.gz"
  sha256 "2ae05466ef44efa7ddb4bce58efc425617583d9196b72e80ec1090bd77df598c"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "fc17d2a6d42dc599cc4a707a445b1bf0201039191f86829c9ed6ef4c9ae7d9ea"
    sha256 cellar: :any,                 arm64_sequoia:  "7568a6130dc642b184063d2b470d2855e0cbc040e80c0f9409aeee9361c80b1b"
    sha256 cellar: :any,                 arm64_sonoma:   "5f63cd8a1cfeab4ed5e0b5b88f63482f88508ea4ee6d3c2c9c16b6fc1cbd8fab"
    sha256 cellar: :any,                 arm64_ventura:  "5e316854c5b156cbc12a6e70b274763c03f7a666ee8288d32bcf6f1d11fff3fb"
    sha256 cellar: :any,                 arm64_monterey: "8043a9272554d530d9c50c84818606c53b75b9178ae7e559be7fc2d87ac75da7"
    sha256 cellar: :any,                 sonoma:         "00e0549fd3b8636a05a906e52e2595d48812790841149e285786242aa9d43a4e"
    sha256 cellar: :any,                 ventura:        "68947fd5c5d573b896c3887edb92f007cd480a5f469a97400712f8b01796b336"
    sha256 cellar: :any,                 monterey:       "0fc17abd9d9e35b278aa4a17cdb8e711c281bf124e46ba47ce88405b0c00533c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6e6863413f8614f33cdc88ecb9d61ede577b74c671096e152a17763b9ba80d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed3e74e7ae581d38be226b8ce71d50168246e349c3b4bd862c79e952560e7eab"
  end

  head do
    url "https://github.com/deadpixi/mtm.git", branch: "master"

    uses_from_macos "ncurses" # 1.2.2+ can use macOS' ncurses 5.7
  end

  depends_on "ncurses" # 1.2.1 requires newer than ncurses 6.1

  def install
    bin.mkpath
    man1.mkpath

    makefile = build.head? ? "Makefile.darwin" : "Makefile"

    system "make", "-f", makefile, "install", "DESTDIR=#{prefix}", "MANDIR=#{man1}"
    system "make", "-f", makefile, "install-terminfo"
  end

  test do
    require "open3"

    env = { "SHELL" => "/bin/sh", "TERM" => "xterm" }
    Open3.popen2(env, bin/"mtm") do |input, output, wait_thr|
      input.puts "printf 'TERM=%s PID=%s\n' $TERM $MTM"
      input.putc "\cG"
      sleep 1
      input.putc "w"

      assert_match "TERM=screen-bce PID=#{wait_thr.pid}", output.read
    end
  end
end
