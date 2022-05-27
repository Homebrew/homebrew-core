class Liquidprompt < Formula
  desc "Adaptive prompt for bash and zsh shells"
  homepage "https://github.com/nojhan/liquidprompt"
  url "https://github.com/nojhan/liquidprompt/archive/v2.1.1.tar.gz"
  sha256 "d6a5e49027ad8f19415460956e6a96b801c379bf3e1b5e3b0941936c6d4153f2"
  license "AGPL-3.0-or-later"
  head "https://github.com/nojhan/liquidprompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e6f9e90371b25e9c21e0926626338c671f7382d6a0c62c7393cba431b0ca21af"
  end

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
    output = shell_output("/bin/bash -c '. #{liquidprompt} --no-activate; lp_theme --list'")
    assert_match "default\n", output
  end
end
