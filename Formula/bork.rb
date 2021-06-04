class Bork < Formula
  desc "Bash-Operated Reconciling Kludge"
  homepage "https://github.com/skylarmacdonald/bork"
  url "https://github.com/skylarmacdonald/bork/archive/v0.12.0.tar.gz"
  sha256 "525f797a5ad01734d298852a038c2a2cb338ee9bb038c560bb20ecf142b1588b"
  license "Apache-2.0"
  head "https://github.com/skylarmacdonald/bork.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "289203782efd4a00e6a3e664780f1c3d5fcc0353f38546557b50bd606b24c9f0"
  end

  def install
    files = %w[types/shells.sh types/pipsi.sh types/cask.sh test/type-pipsi.bats test/type-cask.bats]
    inreplace files, "/usr/local/", HOMEBREW_PREFIX

    prefix.install %w[bin docs lib test types]
  end

  test do
    expected_output = "checking: directory #{testpath}/foo\r" \
                      "missing: directory #{testpath}/foo \n" \
                      "verifying : directory #{testpath}/foo\n" \
                      "* success\n"
    assert_match expected_output, shell_output("#{bin}/bork do ok directory #{testpath}/foo", 1)
  end
end
