class Liquidprompt < Formula
  desc "Adaptive prompt for bash and zsh shells"
  homepage "https://github.com/nojhan/liquidprompt"
  url "https://github.com/nojhan/liquidprompt/archive/v_1.11.tar.gz"
  sha256 "669dde6b8274a57b3e39dc41539d157a86252e40e39bcc4c3102b5a81bd8f2f5"
  head "https://github.com/nojhan/liquidprompt.git"

  bottle :unneeded

  def install
    share.install "liquidpromptrc-dist"
    share.install "liquidprompt"
  end

  def caveats; <<-EOS.undent
    Add the following lines to your bash or zsh config (e.g. ~/.bash_profile):
      if [ -f #{HOMEBREW_PREFIX}/share/liquidprompt ]; then
        . #{HOMEBREW_PREFIX}/share/liquidprompt
      fi
    EOS
  end

  test do
    liquidprompt = "#{HOMEBREW_PREFIX}/share/liquidprompt"
    output = shell_output("/bin/sh #{liquidprompt} 2>&1")
    assert_match "add-zsh-hook: command not found", output
  end
end
