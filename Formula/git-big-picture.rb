class GitBigPicture < Formula
  include Language::Python::Virtualenv

  desc "Visualization tool for Git repositories"
  homepage "https://github.com/git-big-picture/git-big-picture"
  url "https://github.com/git-big-picture/git-big-picture/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "7b2826d72e146c7a53e7a1cc9533c360cd8e0feb870c7d1eadcc189b8bc2c5f6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7646579430d2ab35d1aabe5661be2eacde3da778db1259e962c4c0df78720bf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7646579430d2ab35d1aabe5661be2eacde3da778db1259e962c4c0df78720bf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7646579430d2ab35d1aabe5661be2eacde3da778db1259e962c4c0df78720bf1"
    sha256 cellar: :any_skip_relocation, ventura:        "705f6bfdb8623f2a158fc034a7b51097f4cf541da9db461f9000c33ccdf3d193"
    sha256 cellar: :any_skip_relocation, monterey:       "705f6bfdb8623f2a158fc034a7b51097f4cf541da9db461f9000c33ccdf3d193"
    sha256 cellar: :any_skip_relocation, big_sur:        "705f6bfdb8623f2a158fc034a7b51097f4cf541da9db461f9000c33ccdf3d193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9725b03021184088a0eacfc3beb7d62db8e7a6429a00eb8815d6af2939f96967"
  end

  depends_on "graphviz"
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Empty commit"
    system "git", "big-picture", "-f", "svg", "-o", "output.svg"
    assert_path_exists testpath/"output.svg"
  end
end
