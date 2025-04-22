class GitBigPicture < Formula
  include Language::Python::Virtualenv

  desc "Visualization tool for Git repositories"
  homepage "https://github.com/git-big-picture/git-big-picture"
  url "https://github.com/git-big-picture/git-big-picture/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "cccbd3e35dfe6d0ce86d06079e80cf9219cb25f887c7a782e2808e740dc23c3a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0427911937b4a1b43a56835c6a4d80f1c3513d32cfe571739f56f12979620851"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0427911937b4a1b43a56835c6a4d80f1c3513d32cfe571739f56f12979620851"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0427911937b4a1b43a56835c6a4d80f1c3513d32cfe571739f56f12979620851"
    sha256 cellar: :any_skip_relocation, sonoma:        "0427911937b4a1b43a56835c6a4d80f1c3513d32cfe571739f56f12979620851"
    sha256 cellar: :any_skip_relocation, ventura:       "0427911937b4a1b43a56835c6a4d80f1c3513d32cfe571739f56f12979620851"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e09e1171d0a5c340d69e47b4942a14d5a2c6f797c5b33875ad3c69806b7310f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12e262c0aa73b5a7be00a9b803134175ad2856493590e0f80f2385fcaa3f3c6d"
  end

  depends_on "graphviz"
  depends_on "python@3.13"

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
