class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https://github.com/RubyMetric/chsrc"
  url "https://github.com/RubyMetric/chsrc/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "9985c8e3be047ba47d54650ec284a28314d3221be2636a8c031744241c01f482"
  license "GPL-3.0-or-later"
  head "https://github.com/RubyMetric/chsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53d4a9168f656567782cc306e5fc2d4bc55e20a50a91c612e0f6af1a50e34a12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8915d8c4fbb1ccc2110a405121763d53a520e3468a996d79615b94b6502c21d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e53a86f9d38d700757603d6c222a2cba61fc70800d9f9e6446d72e9078af1b80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6791abc9d81e8f7781c6a1b456c115dadee08a8894112a86ec74fc10cb46590d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dab70cbe9901152120b5a950e52c0590ebfa1b5cc17c8e58bd28ab4d6199989d"
    sha256 cellar: :any_skip_relocation, ventura:       "7d49b57c953c852d16c0f6c5203a4badc83aa102500fded99d033365eb01bdfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4969a3ea64a8245e5195989d698e6a9ff340fee686629a6550fd6287280a1203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29ae178aa9fdab7880156f2a00c099137be3ae117304a7467507d2e2c1eae698"
  end

  def install
    system "make"
    bin.install "chsrc"
  end

  test do
    assert_match(/mirrorz\s*MirrorZ.*MirrorZ/, shell_output("#{bin}/chsrc list"))
    assert_match version.to_s, shell_output("#{bin}/chsrc --version")
  end
end
