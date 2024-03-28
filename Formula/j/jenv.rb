class Jenv < Formula
  desc "Manage your Java environment"
  homepage "https://www.jenv.be/"
  url "https://github.com/jenv/jenv/archive/refs/tags/0.5.7.tar.gz"
  sha256 "5865f7839eda303467fb1ad3dfb606b31566001beeb05360f653905346c2624f"
  license "MIT"
  head "https://github.com/jenv/jenv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "35224b1400c377abd56e99f5e6caec0b48672a935cd3eb250046cf5ab107948e"
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
