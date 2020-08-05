class Pipebench < Formula
  desc "Measure the speed of STDIN/STDOUT communication"
  homepage "http://www.habets.pp.se/synscan/programs.php?prog=pipebench"
  # Upstream server behaves oddly: https://github.com/Homebrew/homebrew/issues/40897
  # url "http://www.habets.pp.se/synscan/files/pipebench-0.40.tar.gz"
  url "https://deb.debian.org/debian/pool/main/p/pipebench/pipebench_0.40.orig.tar.gz"
  sha256 "ca764003446222ad9dbd33bbc7d94cdb96fa72608705299b6cc8734cd3562211"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7a63d8cdd084919304019c06290b7b808f637071c30f688219b47e2cc49f469" => :catalina
    sha256 "7489b10153744c61c74be048fb8c5d0acb4abae2f03437a0a633a312253c3345" => :mojave
    sha256 "9ece6aaf7dcf0e1dbdbba28979ffbb6384f1d69aee8d194db2e009994c655cf2" => :high_sierra
    sha256 "213e31962005a876277c6f8edd3c9cd8964c253496f7945d48aef7338c76277e" => :sierra
    sha256 "353cabdaf04a41e2169c1e489cd038f9fbe7f33cfd24a5a0b3068449ccc3446d" => :el_capitan
    sha256 "a999c7ba2978e60d38bdeec63d1f1a8b2667cb0d77d35c4da2e57212a37b85ac" => :yosemite
    sha256 "c5b0805588d8a8d9047d30b9330dd0be0215bfe694ed662cf11fa84595bba85c" => :mavericks
  end

  def install
    system "make"
    bin.install "pipebench"
    man1.install "pipebench.1"
  end

  test do
    system "#{bin}/pipebench", "-h"
  end
end
