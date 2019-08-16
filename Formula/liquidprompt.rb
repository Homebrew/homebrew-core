class Liquidprompt < Formula
  desc "Adaptive prompt for bash and zsh shells"
  homepage "https://github.com/nojhan/liquidprompt"
  url "https://github.com/nojhan/liquidprompt/archive/eda83efe4e0044f880370ed5e92aa7e3fdbef971.tar.gz"
  sha256 "ed4715bebe2ef573a244a49780ab6809403b25645a4b16cc30cac6b71cdaf25c"
  head "https://github.com/nojhan/liquidprompt.git", :branch => "master"

  bottle :unneeded

  def install
    share.install "liquidpromptrc-dist"
    share.install "liquidprompt"
  end

  def caveats; <<~EOS
    Add the following lines to your bash or zsh config (e.g. ~/.bash_profile):
      if [ -f #{HOMEBREW_PREFIX}/share/liquidprompt ]; then
        . #{HOMEBREW_PREFIX}/share/liquidprompt
      fi

    If you'd like to reconfigure options, you may do so in ~/.liquidpromptrc.
    A sample file you may copy and modify has been installed to
      #{HOMEBREW_PREFIX}/share/liquidpromptrc-dist
  EOS
  end

  test do
    liquidprompt = "#{HOMEBREW_PREFIX}/share/liquidprompt"
    output = shell_output("/bin/sh #{liquidprompt} 2>&1")
    assert_match "add-zsh-hook: command not found", output
  end
end
