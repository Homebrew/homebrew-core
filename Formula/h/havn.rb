class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https://github.com/mrjackwills/havn"
  url "https://github.com/mrjackwills/havn/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "1648ad392093ea3dee85e9a1d6c8309a1733034f3f489fb0d6ef2289f0babca4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "097c569ae386d7ce4b8ed8879102a2938087a54f31ea119da7a36e4d380efafe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aaa5f2cc08ed86e7668c76867ff23eb74e817522b00e39fc814ec89d2bd13a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42d81bf99cc01314d5f38d0c7dc709b74ea72b8ff4805625f44c3e2ce04b2ba8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0be09461e4936c64c4e5954fad4fd9e64be79bca379e578f63583a2395f2219a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "900e082d98860e20d6a8cd9d5a385525ce5be7be616840d50ddaa5ab6866683c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f417347f406ba5056c301827111895064d0f7d5f77c76afd60dcaef6c828f607"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/havn example.com -p 443 -r 6")
    assert_match "1 open\e[0m, \e[31m0 closed", output

    assert_match version.to_s, shell_output("#{bin}/havn --version")
  end
end
