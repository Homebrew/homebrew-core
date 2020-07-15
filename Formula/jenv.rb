class Jenv < Formula
  desc "Manage your Java environment"
  homepage "https://www.jenv.be/"
  url "https://github.com/jenv/jenv/archive/0.5.3.tar.gz"
  sha256 "b30b1a4c2a213f01c89ac111df1be7e027a93512e34d14cdbdd263a0fbec5fff"
  license "MIT"

  head "https://github.com/jenv/jenv.git"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jenv"
  end

  def caveats
    <<~EOS
      To activate jenv, add the following to your #{shell_profile}:

        export PATH="$HOME/.jenv/bin:$PATH"
        eval "$(jenv init -)"
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/jenv init -)\" && jenv versions")
  end
end
