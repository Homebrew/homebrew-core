class GitBigPicture < Formula
  include Language::Python::Virtualenv

  desc "Visualization tool for Git repositories"
  homepage "https://github.com/git-big-picture/git-big-picture"
  url "https://github.com/git-big-picture/git-big-picture/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "cccbd3e35dfe6d0ce86d06079e80cf9219cb25f887c7a782e2808e740dc23c3a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a8fb9cb33fb8a664d0f5bf74b8a5a7694a0db0d6ba42523b9e88edddb72d590"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a8fb9cb33fb8a664d0f5bf74b8a5a7694a0db0d6ba42523b9e88edddb72d590"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a8fb9cb33fb8a664d0f5bf74b8a5a7694a0db0d6ba42523b9e88edddb72d590"
    sha256 cellar: :any_skip_relocation, sonoma:         "29bffa758928cea7adcc02a301c83b9586d6a3e5af2f79c0f23f8c7090c903a4"
    sha256 cellar: :any_skip_relocation, ventura:        "29bffa758928cea7adcc02a301c83b9586d6a3e5af2f79c0f23f8c7090c903a4"
    sha256 cellar: :any_skip_relocation, monterey:       "29bffa758928cea7adcc02a301c83b9586d6a3e5af2f79c0f23f8c7090c903a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "717a81a389a8aae9a59d946a80251ed46cd0cf089405e2e9213ec132c085077b"
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
