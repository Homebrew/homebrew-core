class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.9.7.tar.gz"
  sha256 "0914a243b2f2f38b79fd375a6fc2891cf642052c3a28e762e0f80a9c9cb3a173"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b44e40e5c70966d5234f87e385f234450edd1b37d22630efcf102f9a9e276ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b44e40e5c70966d5234f87e385f234450edd1b37d22630efcf102f9a9e276ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b44e40e5c70966d5234f87e385f234450edd1b37d22630efcf102f9a9e276ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b98502b5e1edee2febd08909376b3467d6736f63c410c2984742c9327b58904"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ed79cbab817868d2ce77b37601a910f129f1fafd672d66159e4c36897eb9d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efbcddcd63bb5abf9b9b3830d4052d65ea4385b2b268d0b1ca80a1c33dfc23a1"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
