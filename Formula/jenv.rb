class Jenv < Formula
  desc "Manage your Java environment"
  homepage "https://www.jenv.be/"
  url "https://github.com/jenv/jenv/archive/0.5.2.tar.gz"
  sha256 "4cdce828bfaeb6561733bab641ed2912107a8bc24758a17f2387ee78403afb9a"

  head "https://github.com/gcuisinier/jenv.git"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jenv"
  end

  def caveats
    <<~EOS
      To activate jenv, add the following to your .zshrc:

        export PATH="$HOME/.jenv/bin:$PATH"
        eval "$(jenv init -)"

      To add Java Environment to jenv, List and add the Java environments as:

        /usr/libexec/java_home

      Output would be something like this, in multiple of depending on how
      many JDK you have installed:

        /Library/Java/JavaVirtualMachines/jdk-10.0.1.jdk/Contents/Home

      Add it to jenv as:

        jenv add /Library/Java/JavaVirtualMachines/jdk-10.0.1.jdk/Contents/Home

      Check available versions after you have added them to jenv as:

        jenv versions

      Activate Java version as:

        jenv shell 10.0

      Additionally you can create 'jenvrc' file inside the root directory of your
      project of simple any directory with content:

        java=1.10
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/jenv init -)\" && jenv versions")
  end
end
