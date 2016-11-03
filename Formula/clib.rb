class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.8.0.tar.gz"
  sha256 "75641bfba02b989ef338b4f3fdf20402d6a119c9fa7d755c9362604bb016116f"

  head "https://github.com/clibs/clib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ca51cac3894a691d764d2c3f898c4f2886acd515b7b8329be4604da345be4c8" => :sierra
    sha256 "49a968b7a2996481bc3481477decdb546af828fc31a3efa68bbf8088a189caef" => :el_capitan
    sha256 "cea4541a53eb7b83e3a851ceb2a16fcccf3ba31a2d5b2e31f76a9d5c157da427" => :yosemite
    sha256 "bc5b305a7ca4c4c16fcb135dc43090887e657d4c78497df25cef888d45fa2952" => :mavericks
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
