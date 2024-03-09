class GitBigPicture < Formula
  desc "Visualization tool for Git repositories"
  homepage "https://github.com/git-big-picture/git-big-picture"
  url "https://github.com/git-big-picture/git-big-picture/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "cccbd3e35dfe6d0ce86d06079e80cf9219cb25f887c7a782e2808e740dc23c3a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e32bf0a1821ac3c0ff666e9a16954c40698decc2646ca027f78ecf520e9ca546"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9bb60949ebaebd8f969419356525089b9fa3cf970013b93e1d250572dd0cc24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9bbf5fa232fb7371fab85bff33aefb70622d68801981f412d45556c8cbe0db3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9b514f7218fcddc4c71fdd0cc79a5d2fc28864c0783d05eb034d28850bec8f8"
    sha256 cellar: :any_skip_relocation, ventura:        "4340c58181355c6537fa114f79b2b565c5e612519eccb6163c93bb26182fe6db"
    sha256 cellar: :any_skip_relocation, monterey:       "b80d83dfd9e5a541d6119c5dfe6a6ff382a7558f1cecc6b0e8b23819d683e4c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4426f7e5e795ea5c34c996a707e1144d50bdfcda3e45d66919ad48c29ed8345"
  end

  depends_on "python-setuptools" => :build
  depends_on "graphviz"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Empty commit"
    system "git", "big-picture", "-f", "svg", "-o", "output.svg"
    assert_path_exists testpath/"output.svg"
  end
end
