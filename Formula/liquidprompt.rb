class Liquidprompt < Formula
  desc "Adaptive prompt for bash and zsh shells"
  homepage "https://github.com/nojhan/liquidprompt"
  url "https://github.com/nojhan/liquidprompt/archive/eda83efe4e0044f880370ed5e92aa7e3fdbef971.zip"
  sha256 "a8684ee8157f78e8e4d982b51fc1ade0100ddbdfe4eeb7158e0ab1c45b020a17"
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
