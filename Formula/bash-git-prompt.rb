class BashGitPrompt < Formula
  desc "Informative, fancy bash prompt for Git users"
  homepage "https://github.com/magicmonty/bash-git-prompt"
  url "https://github.com/magicmonty/bash-git-prompt/archive/2.6.2.tar.gz"
  sha256 "42ba16d96da0f5bcf577123ec7e819eea8f6893d123e485468b905be3e53bee8"
  head "https://github.com/magicmonty/bash-git-prompt.git"

  bottle :unneeded

  def install
    share.install "gitprompt.sh", "gitprompt.fish", "git-prompt-help.sh",
                  "gitstatus.py", "gitstatus.sh", "gitstatus_pre-1.7.10.sh",
                  "prompt-colors.sh"

    (share/"themes").install Dir["themes/*.bgptheme"], "themes/Custom.bgptemplate"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    You should add the following to your .bashrc (or equivalent):
      if [ -f #{HOMEBREW_PREFIX}/opt/bash-git-prompt/share/gitprompt.sh ]; then
        __GIT_PROMPT_DIR=#{HOMEBREW_PREFIX}/opt/bash-git-prompt/share
        source #{HOMEBREW_PREFIX}/opt/bash-git-prompt/share/gitprompt.sh
      fi
    EOS
  end
end
