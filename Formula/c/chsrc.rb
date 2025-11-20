class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https://github.com/RubyMetric/chsrc"
  url "https://github.com/RubyMetric/chsrc/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "d33df6abe8269c8abdaadc5b1cfde8a53676d1a52db659688ffdf3a605647ce9"
  license "GPL-3.0-or-later"
  head "https://github.com/RubyMetric/chsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e5284d12fc7a7a26591a964f35f638c46d8ad339d9e046323b12f6ae14a94c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "207c14f7c2c966a785ac0618f4d199c35eaee2fc39f33a44e619aad1df67b376"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60d5f9128a554a8566f137a271383d94479deb92ea6608d05426ed73dddfe14e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b756dd9f5c1fb8a5cbc2c27c852e44546894d2c1193fee7c3701d69072e3d83a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5632382efd3b6d53327894bc60d3c942ad917c49698769a26fef6025bdfaed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d5a78177dfb3efb005d5ed2d05591296f45eff83d5c94f2865a345d70999e36"
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
