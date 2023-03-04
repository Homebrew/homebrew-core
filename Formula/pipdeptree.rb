class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/85/68/96968fa426c146e7a3bde19b06110e324ed0f5ed3892e63ae356084ebbbd/pipdeptree-2.5.2.tar.gz"
  sha256 "787c994f7d2cff9c3d55750590fd212dabc8ff87e4690624eabb449a49dfd41d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1f0af62299bb5468c1b59c1bf5c635c2cc212accad48f2e801ac79757390d6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d895cf3bd806c4485b7e8b0232d7a125ecafad201c381cb3c493765b350066da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97d8185ae51c5261af4a130712506762d2c9dc485fb58121263446f857a85d98"
    sha256 cellar: :any_skip_relocation, ventura:        "85280a08cf5a74337d57683783c2284457721b5ac987b6ef1e876dbb628534e4"
    sha256 cellar: :any_skip_relocation, monterey:       "6de2acb3b5fc51beffa059ed4279b40f8277f85820d55c727c5e15bf2b260228"
    sha256 cellar: :any_skip_relocation, big_sur:        "12a2bb173bd0d8c3e453d9b4dc54d3e4f90668cd5362beb69103846f5b5b6b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a664e47943b88becd45376df7b5c3a6c979dce71b07756a9c07a4894159b440"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
