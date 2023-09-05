class Autoenv < Formula
  desc "Per-project, per-directory shell environments"
  homepage "https://github.com/hyperupcall/autoenv"
  url "https://github.com/hyperupcall/autoenv/archive/v0.3.0.tar.gz"
  sha256 "1194322a0fd95e271bbfeb39e725ee33627154f80eb76620cf0cd01e0d5e3520"
  license "MIT"
  head "https://github.com/hyperupcall/autoenv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "879dc65b4f4740aed9cf1960c2b2da66f877f10c4ad774084373e36097d8efb0"
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
