class Jenv < Formula
  desc "Manage your Java environment"
  homepage "https://www.jenv.be/"
  url "https://github.com/jenv/jenv/archive/0.5.5.tar.gz"
  sha256 "691e819e5a803054d4714539bd5ee5de73d6c3b2bcbee825f5013a7f75930493"
  license "MIT"
  revision 2
  head "https://github.com/jenv/jenv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e27ff89af1af1cbcbfd3b46d99f1c97f1badbbb9a76cbca22a4400ede1e5acb0"
  end

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jenv"
    fish_function.install_symlink Dir[libexec/"fish/*.fish"]
  end

  def caveats
    if preferred == :fish
      <<~EOS
        To activate jenv, run the following commands:
          echo 'status --is-interactive; and source (jenv init -|psub)' >> #{shell_profile}
      EOS
    else
      <<~EOS
        To activate jenv, add the following to your #{shell_profile}:
          export PATH="$HOME/.jenv/bin:$PATH"
          eval "$(jenv init -)"
      EOS
    end
  end

  test do
    shell_output("eval \"$(#{bin}/jenv init -)\" && jenv versions")
  end
end
