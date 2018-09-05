class Autoenv < Formula
  desc "Per-project, per-directory shell environments"
  homepage "https://github.com/kennethreitz/autoenv"
  url "https://github.com/kennethreitz/autoenv/archive/v0.2.1.tar.gz"
  sha256 "d10ee4d916a11a664453e60864294fec221c353f8ad798aa0aa6a2d2c5d5b318"
  head "https://github.com/kennethreitz/autoenv.git"

  bottle :unneeded

  def install
    prefix.install "activate.sh"
  end

  def caveats; <<~EOS
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
