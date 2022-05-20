class Liquidprompt < Formula
  desc "Adaptive prompt for bash and zsh shells"
  homepage "https://github.com/nojhan/liquidprompt"
  url "https://github.com/nojhan/liquidprompt/archive/v2.0.5.tar.gz"
  sha256 "aec7a1a2d2b5aee5db30895ebe8fddde2f59db0e23fbf55e627acc0551b16465"
  license "AGPL-3.0-or-later"
  head "https://github.com/nojhan/liquidprompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c04a2b629a7a9f72f1e0823a6ffa707fc89d2c640dc6f28d1cf1a65ecee4767"
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
