class BashGitPrompt < Formula
  desc "Informative, fancy bash prompt for Git users"
  homepage "https://github.com/magicmonty/bash-git-prompt"
  url "https://github.com/magicmonty/bash-git-prompt/archive/2.6.3.tar.gz"
  sha256 "c941b6b34a01ef2e30c8a54bbd908a5ebd8d3e20694dc1a7e84ccbec57258421"
  head "https://github.com/magicmonty/bash-git-prompt.git"

  bottle :unneeded

  def install
    share.install "gitprompt.sh", "gitprompt.fish", "git-prompt-help.sh",
                  "gitstatus.py", "gitstatus.sh", "gitstatus_pre-1.7.10.sh",
                  "prompt-colors.sh"

    (share/"themes").install Dir["themes/*.bgptheme"], "themes/Custom.bgptemplate"
    doc.install "README.md"
  end

  def caveats; <<~EOS
    You should add the following to your .bashrc (or equivalent):
      if [ -f "#{HOMEBREW_PREFIX}/opt/bash-git-prompt/share/gitprompt.sh" ]; then
        __GIT_PROMPT_DIR="#{HOMEBREW_PREFIX}/opt/bash-git-prompt/share"
        source "#{HOMEBREW_PREFIX}/opt/bash-git-prompt/share/gitprompt.sh"
      fi
    EOS
  end
end
