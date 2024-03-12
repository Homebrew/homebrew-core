class GitSweep3k < Formula
  include Language::Python::Virtualenv

  desc "Clean up branches from your Git remotes"
  homepage "https://github.com/myint/git-sweep"
  url "https://files.pythonhosted.org/packages/12/1b/ef0f82ac34778c39b388771df670d548f56e54f0113f2faca4404eb13f54/git-sweep3k-0.3.1.tar.gz"
  sha256 "e3244b72d5140f77842f1125376a85053737b75cd2502a32860d5a65638f99a8"
  license "MIT"
  head "https://github.com/myint/git-sweep.git", branch: "master"

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: git-sweep", shell_output("#{bin}/git-sweep -h")
  end
end
