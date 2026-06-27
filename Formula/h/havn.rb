class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https://github.com/mrjackwills/havn"
  url "https://github.com/mrjackwills/havn/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "a9633b2e509591bff8fb0ac36e0e04600a74ad98c0cdcb4a9c5bff48751fe51c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80effddbf9cd0ab82bc48db616c239b4ac183f3434ced0a661c144c31028745f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "695911f9beda78d855ac1b704e3913cdd3ab9e9adb531e9b85b3f649f6483d9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f7b71c3a026e27cd55550e273a308f269e132920e7a087dc77281a037959ca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "197791ac62027f052b0ba02a15be889290d52be47d6e75e7373873bed8c095fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "092c984b553e08ffa39211865d0ccde1ce86ed41bf5d2eda558fe661bd311abb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d71e486efa3ffee2132834356f5f9a4f1beaeab91e165bc9341bed86e7993858"
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
