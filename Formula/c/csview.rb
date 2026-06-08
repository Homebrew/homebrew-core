class Csview < Formula
  desc "High performance csv viewer for cli"
  homepage "https://github.com/wfxr/csview"
  url "https://github.com/wfxr/csview/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "91fadcddef511265f4bf39897ce4a65c457ac89ffd8dd742dc209d30bf04d6aa"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/wfxr/csview.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8737fd09dc38bfd517f18fbc77fdeefaa5e81be68c1cbf2f9229cf4496c63267"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25e89b345b9a280bb3e1ed9131878aa372277f1b8ac5647938f4056fd8267a97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e558ed523b25a07d5d6110f2686154c2f1b43ee5fe4e28cc63d1287f475292c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "726c20bdf56990f680feea91504782ff3ed966ff27a4d63ac2fd7d8e9244e70c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0cfc60d188ba14a0d17909bcf78e21673ee65aee2d0bfadd28ffaa741ce2816"
    sha256 cellar: :any_skip_relocation, ventura:       "46a886931cb6f7876fa7dca415a2d25f61063e69a4d47dd1fa7eb2726f2bc41e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cff3b9c1289a699084743bfaf49933d7c30903cd8096fb63f1f1d7039accb762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dcad326ae8950b1557bdf2dc4e6477ae867a0f4f05211373bde145c87154e7c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    zsh_completion.install  "completions/zsh/_csview"
    bash_completion.install "completions/bash/csview.bash" => "csview"
    fish_completion.install "completions/fish/csview.fish"
  end

  test do
    (testpath/"test.csv").write("a,b,c\n1,2,3")
    assert_equal <<~EOS, shell_output("#{bin}/csview #{testpath}/test.csv")
      ┌───┬───┬───┐
      │ a │ b │ c │
      ├───┼───┼───┤
      │ 1 │ 2 │ 3 │
      └───┴───┴───┘
    EOS
  end
end
