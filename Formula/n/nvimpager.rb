class Nvimpager < Formula
  desc "Use NeoVim as a pager to view manpages, diffs, etc."
  homepage "https://github.com/lucc/nvimpager"
  url "https://github.com/lucc/nvimpager/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "8255c39697b213cb34dfd573d90c27db7f61180d4a12f640ef6e7f313e525241"
  license "BSD-2-Clause"
  head "https://github.com/lucc/nvimpager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4814f2fa4abc9b5b3388de2a29d97ef491f487573c45295500fece9831fc12d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9e64c6a58d03492445e9ea60bcd47d617310e062ed4a2039824a25050dcda0c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d2255736ecfd77f610057c33437ac6422f8029e51ab588da789901047d950c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "247acb9bf098f61319d45b3c3ecd0ade4338506bf189f57e4a0e171b0d3ebdf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73a19ab94071d95e746c648c8d5797dcccbdaf46cb0773026b72e0d13a3f660f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e5fabfc49fc98011785dfcc6f26a87eaac964f2b4817efc8f1075ca2d8f9e26"
    sha256 cellar: :any_skip_relocation, ventura:        "a1e02ea48f0923ae29d88f732759b2d9b8d848db0edbbb3db779ea630aae6688"
    sha256 cellar: :any_skip_relocation, monterey:       "bdd6f62a23532d21a0350765d7074a9fadf91c94f91941fb4a953bd11165041d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4814f2fa4abc9b5b3388de2a29d97ef491f487573c45295500fece9831fc12d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e843773be2cca6cb16f7bcd029b6f83a8fcfb0b9578ca6f8bf009b43255c9f74"
  end

  depends_on "scdoc" => :build
  depends_on "neovim"

  uses_from_macos "bash"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      To use nvimpager as your default pager, add `export PAGER=nvimpager`
      to your shell configuration.
    EOS
  end

  test do
    (testpath/"test.txt").write <<~EOS
      This is test
    EOS

    assert_match(/This is test/, shell_output("#{bin}/nvimpager test.txt"))
  end
end
