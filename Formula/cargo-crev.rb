class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "c66a057df87dda209ecca31d83da7ef04117a923d9bfcc88c0d505b30dabf29b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21c4a1616392b2e0b8bef2f3ee867231d138eae7f009af927b826876da8801bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f007ff85b9772160639157d4f1cf9990613a382ff23d180bf6ecbe4fba9a402b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03f64a893028318d84526f826c188ffe27045238919aa2be7e1995585c462b58"
    sha256 cellar: :any_skip_relocation, ventura:        "4d260a99096e544c060ba68e5b6be77b900b369412141d4e1c1cb987b23d51ec"
    sha256 cellar: :any_skip_relocation, monterey:       "9c6dcfd6b0d8fd2f3930b1322e0a95978a75913643a93f897168c47f176d00d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "96144493e01326e38243430706551ee1ce0715a273da689242da971f935d0a55"
    sha256 cellar: :any_skip_relocation, catalina:       "f42f08cdb84d4226a63c0cf265d297d02cec4e3264a12f3acb963274a069cd09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f00aeb5c5f3d6f6724e2edee802191a0382ca7fa570e7078e90e2c888cf2f85"
  end

  depends_on "rust" => [:build, :test]

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "./cargo-crev")
  end

  test do
    system "cargo", "crev", "config", "dir"
  end
end
