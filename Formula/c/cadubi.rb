class Cadubi < Formula
  desc "Creative ASCII drawing utility"
  homepage "https://github.com/statico/cadubi/"
  url "https://github.com/statico/cadubi/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "624f85bb16d8b0bc392d761d1121828d09cfc79b3ded5b1220e9b4262924a1a0"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c2832e6449cf5fd7ebbadd2427732b242633ba5ad041046e94e80da63e963e6"
  end

  def install
    inreplace "cadubi", "$Bin/help.txt", "#{doc}/help.txt"
    bin.install "cadubi"
    doc.install "help.txt"
    man1.install "cadubi.1"
  end

  test do
    output = pipe_output("script -q /dev/null #{bin}/cadubi -v", "cat")
    assert_match "cadubi (Creative ASCII Drawing Utility By Ian) #{version}", output
  end
end
