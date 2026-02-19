class Jenv < Formula
  desc "Manage your Java environment"
  homepage "https://github.com/jenv/jenv"
  url "https://github.com/jenv/jenv/archive/refs/tags/0.6.0.tar.gz"
  sha256 "2897ac544007a2c651bb3c02985143c94f4e1234b9c3c6cb2e436442b17cbc74"
  license "MIT"
  head "https://github.com/jenv/jenv.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "41e433160ef6ac63f3b9d2d07ace490965d38a4125380e65930d8fd5670592c7"
  end

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jenv"
    fish_function.install_symlink Dir[libexec/"fish/*.fish"]
  end

  def caveats
    <<~EOS
      To activate jenv, add the following to your shell profile e.g. ~/.profile
      or ~/.zshrc:
        export PATH="$HOME/.jenv/bin:$PATH"
        eval "$(jenv init -)"
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/jenv init -)\" && jenv versions")
  end
end
