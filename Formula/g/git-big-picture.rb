class GitBigPicture < Formula
  include Language::Python::Virtualenv

  desc "Visualization tool for Git repositories"
  homepage "https://github.com/git-big-picture/git-big-picture"
  url "https://github.com/git-big-picture/git-big-picture/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "7b2826d72e146c7a53e7a1cc9533c360cd8e0feb870c7d1eadcc189b8bc2c5f6"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8de6bbe8b5c7293c1f6e575852a38c6b65b00cdd190c55230a53c6bdfcfd10b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ad313fc8c69a6f17d6c915f379fa40b84a61455ff5460e1a17683ba1623975f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "380bdacca80e26c09b989e5442b440a2fd86ff3f1020d7bc89855b207a8c8170"
    sha256 cellar: :any_skip_relocation, sonoma:         "356f88202af3e98cd99916751973845ffa16e1c6718478207aad53a0f0ef7324"
    sha256 cellar: :any_skip_relocation, ventura:        "696a271d7e38776f12fcea58b3c01f06b0439ed20aa99e054705642b3cb77341"
    sha256 cellar: :any_skip_relocation, monterey:       "502bb70f3206a39565d8d680ed90be45b5417da759f7b15133bc40ac61a7415a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f41d674a0efc5e158ff3fea38fe417cb9d50a018238955a0c41a7aa38f9a6aca"
  end

  depends_on "graphviz"
  depends_on "python@3.12"

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
