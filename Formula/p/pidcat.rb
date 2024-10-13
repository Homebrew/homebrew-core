class Pidcat < Formula
  include Language::Python::Shebang

  desc "Colored logcat script to show entries only for specified app"
  homepage "https://github.com/JakeWharton/pidcat"
  url "https://github.com/JakeWharton/pidcat/archive/refs/tags/2.1.0.tar.gz"
  sha256 "e6f999ee0f23f0e9c9aee5ad21c6647fb1a1572063bdccd16a72464c8b522cb1"
  license "Apache-2.0"
  head "https://github.com/JakeWharton/pidcat.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2d0412351f2c3bc45c8b43d8aa9a9e3f1892f22824db054008d1efbef344a3d4"
  end

  depends_on "python@3.12"

  def install
    rewrite_shebang detected_python_shebang, "pidcat.py"
    bin.install "pidcat.py" => "pidcat"

    bash_completion.install "bash_completion.d/pidcat"
    zsh_completion.install "zsh-completion/_pidcat"
  end

  test do
    output = shell_output("#{bin}/pidcat com.oprah.bees.android 2>&1", 1)
    assert_match "No such file or directory: 'adb'", output

    assert_match version.to_s, shell_output("#{bin}/pidcat --version")
  end
end
