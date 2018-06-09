class BashGitPrompt < Formula
  desc "Informative, fancy bash prompt for Git users"
  homepage "https://github.com/magicmonty/bash-git-prompt"
  url "https://github.com/magicmonty/bash-git-prompt/archive/2.7.1.tar.gz"
  sha256 "5e5fc6f5133b65760fede8050d4c3bc8edb8e78bc7ce26c16db442aa94b8a709"
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
    You should add the following to your .bashrc (or .bash_profile):
      if [ -f "#{opt_share}/gitprompt.sh" ]; then
        __GIT_PROMPT_DIR="#{opt_share}"
        source "#{opt_share}/gitprompt.sh"
      fi
  EOS
  end

  test do
    output = shell_output("/bin/sh #{share}/gitstatus.sh 2>&1")
    assert_match "Not a git repository", output
  end
end
