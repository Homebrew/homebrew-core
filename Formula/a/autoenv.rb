class Autoenv < Formula
  desc "Per-project, per-directory shell environments"
  homepage "https://github.com/hyperupcall/autoenv"
  url "https://github.com/hyperupcall/autoenv/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "baf91afe2e93b071dbf3da0c9ad294c1858efd9c8de4b0845f7fb2f31520b252"
  license "MIT"
  head "https://github.com/hyperupcall/autoenv.git", branch: "main"

  bottle do
    manifest_sha256 "3144d91d73fa7c7e020262c405100d923ffb4608165bd2a90c04dc6ea16e3e98"
    sha256 cellar: :any_skip_relocation, all: "7d291627ba82fc28ef378728ea6969eb3cebed1e8b2c17b9655cf05745102362"
  end

  # https://github.com/hyperupcall/autoenv/issues/270
  deprecate! date: "2026-11-23", because: :checksum_mismatch
  disable! date: "2027-11-23", because: :checksum_mismatch

  depends_on "bash"

  deny_network_access!

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
