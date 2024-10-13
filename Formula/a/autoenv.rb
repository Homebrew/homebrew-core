class Autoenv < Formula
  desc "Per-project, per-directory shell environments"
  homepage "https://github.com/hyperupcall/autoenv"
  url "https://github.com/hyperupcall/autoenv/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "1194322a0fd95e271bbfeb39e725ee33627154f80eb76620cf0cd01e0d5e3520"
  license "MIT"
  head "https://github.com/hyperupcall/autoenv.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7336af16659bda14e0ee3e36fca9cd526236c4261b9b801950cc2dcdf617a2d7"
  end

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
