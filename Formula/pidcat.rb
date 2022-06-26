class Pidcat < Formula
  desc "Colored logcat script to show entries only for specified app"
  homepage "https://github.com/JakeWharton/pidcat"
  url "https://github.com/JakeWharton/pidcat/archive/2.1.0.tar.gz"
  sha256 "e6f999ee0f23f0e9c9aee5ad21c6647fb1a1572063bdccd16a72464c8b522cb1"
  license "Apache-2.0"
  head "https://github.com/JakeWharton/pidcat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "040e4e6968c1b152d7b25104e3b4cd27c86df790bc0d863f6ad7371c761d5386"
  end

  def install
    bin.install "pidcat.py" => "pidcat"
    bash_completion.install "bash_completion.d/pidcat"
    zsh_completion.install "zsh-completion/_pidcat"
  end

  test do
    assert_match(/^usage: pidcat/, shell_output("#{bin}/pidcat --help").strip)
  end
end
