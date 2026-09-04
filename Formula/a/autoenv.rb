class Autoenv < Formula
  desc "Per-project, per-directory shell environments"
  homepage "https://github.com/hyperupcall/autoenv"
  url "https://github.com/hyperupcall/autoenv/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "1530fdb0ef41c5f641dfb680d71ba414a87119172ca0125313859e8c67d9c8ad"
  license "MIT"
  revision 1
  head "https://github.com/hyperupcall/autoenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d291627ba82fc28ef378728ea6969eb3cebed1e8b2c17b9655cf05745102362"
  end

  depends_on "bash"

  def install
    prefix.install "activate.sh"
  end

  def caveats
    <<~EOS
      To finish the installation, source activate.sh in your shell:
        source #{opt_prefix}/activate.sh
    EOS
  end

  test do
    (testpath/"test/.env").write "echo it works\n"
    testcmd = "yes | bash -c '. #{prefix}/activate.sh; autoenv_cd test'"
    assert_match "it works", shell_output(testcmd)
  end
end
