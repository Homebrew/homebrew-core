class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/v2.5.1.tar.gz"
  sha256 "fee065673c3b9cf036b51d67672a8ede060652d803eef98fe490fbe8d83b2a7c"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fceac06a83052ab1a67a5845ebc910438105e543677756c774c05b3a03a81c8" => :mojave
    sha256 "0b0552a903e6a0a29fbf38c1d2110263df22fd5a12599e36cd60b22bc1dab71e" => :high_sierra
    sha256 "1e3250586c714b629398dc02cd1b8168fe0cfe70a8a067d700b8b425f16d2ffa" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/charm"
  end

  test do
    assert_match "show-plan           - show plan details", shell_output("#{bin}/charm 2>&1")

    assert_match "ERROR missing plan url", shell_output("#{bin}/charm show-plan 2>&1", 2)
  end
end
