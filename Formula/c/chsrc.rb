class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https://github.com/RubyMetric/chsrc"
  url "https://github.com/RubyMetric/chsrc/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "74210e232f15bb23b4c222d69077bfa6d6fc84c2f4043b86757c160038c4d96f"
  license "GPL-3.0-or-later"
  head "https://github.com/RubyMetric/chsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e482ca9c0bf03e90ecbe263217099fe1b0b8d61a6feb4296432000653ab3aae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a36af7d620a98399b8dc0f55fd70c99837054c4940376320cb8f3b115bb0e57f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5028dfde26ffeabfd7286ada46fae7e87df33993791e0f77489f520ea820fcce"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e9a849604e7067862b86325a87171c764f6ac214bc1f130b3cedd1ad794d20e"
    sha256 cellar: :any_skip_relocation, ventura:       "a74e2292800322a63a90de0074a19aae4b6d2adc696822bb29d62730b6fce318"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ad23100e6283e788157bc1fea0564ad677ab807d970ed608558c241c638d783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef3bc293723b69d4e77c0a93df587d1398b931cbab53c63b41abb58be235ccfa"
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
