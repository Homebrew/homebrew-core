class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https://chsrc.run/"
  url "https://github.com/RubyMetric/chsrc/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "a3fb56035dc53f662f3b78ad951db17de0300d103cb412e1c334621c3b881b13"
  license "GPL-3.0-or-later"
  head "https://github.com/RubyMetric/chsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a7b8cb08752253481f1e49338fc928a66c498697c5ed244f819e8c0468cbfb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a69cfe2318fc6b78b425e9ad7479f6fd20aeefeb3729ba1e102d615f3ded4c7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea4c96f4f5d64c22974d70db7af45e9e7326311d44eab7fcdcd24f1d319510f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a858db8c54b9223087b0e13427fbef6c4e30dd8389b0a2c87cde38e4214c455f"
    sha256 cellar: :any,                 arm64_linux:   "41497163995d010ffd5734692d48a7a1d85d1b23b64b7c374afe65ca41841bf6"
    sha256 cellar: :any,                 x86_64_linux:  "32c61defae7463f66119e40c5ec35a89c56359b8791b81db6370c7d55f2e40e3"
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
