class Liquidprompt < Formula
  desc "Adaptive prompt for bash and zsh shells"
  homepage "https://github.com/nojhan/liquidprompt"
  url "https://github.com/nojhan/liquidprompt/archive/v2.0.2.tar.gz"
  sha256 "4dc66ebb0e74cf020cc9e18495b92db52848609519444f3243b46f266a47e9e2"
  license "AGPL-3.0-or-later"
  head "https://github.com/nojhan/liquidprompt.git", branch: "master"

  bottle :unneeded

  def install
    share.install "liquidpromptrc-dist"
    share.install "liquidprompt"
  end

  def caveats
    <<~EOS
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
    output = shell_output("/bin/sh -c '. #{liquidprompt} --no-activate; lp_theme --list'")
    assert_match "default\n", output
  end
end
