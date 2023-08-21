class Liquidprompt < Formula
  desc "Adaptive prompt for bash and zsh shells"
  homepage "https://github.com/nojhan/liquidprompt"
  url "https://github.com/nojhan/liquidprompt/archive/v2.1.2.tar.gz"
  sha256 "f752f46595519befd1ad83eaa3605cfc05babd485250a0b46916d8eacabf4f26"
  license "AGPL-3.0-or-later"
  head "https://github.com/nojhan/liquidprompt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0fedfbfa90aeb2eb693a83409f6b3a4bf4b51052143b61a90fd37f543baeeb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0fedfbfa90aeb2eb693a83409f6b3a4bf4b51052143b61a90fd37f543baeeb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0fedfbfa90aeb2eb693a83409f6b3a4bf4b51052143b61a90fd37f543baeeb5"
    sha256 cellar: :any_skip_relocation, ventura:        "f0fedfbfa90aeb2eb693a83409f6b3a4bf4b51052143b61a90fd37f543baeeb5"
    sha256 cellar: :any_skip_relocation, monterey:       "f0fedfbfa90aeb2eb693a83409f6b3a4bf4b51052143b61a90fd37f543baeeb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0fedfbfa90aeb2eb693a83409f6b3a4bf4b51052143b61a90fd37f543baeeb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b8c4b3ad9ab0683c644d021b66cfaea74661cede9fcbb188d555bb65825903e"
  end

  def install
    share.install "liquidprompt"
  end

  def caveats
    <<~EOS
      Add the following lines to your bash or zsh config (e.g. ~/.bash_profile):
        if [ -f #{HOMEBREW_PREFIX}/share/liquidprompt ]; then
          . #{HOMEBREW_PREFIX}/share/liquidprompt
        fi

      If you'd like to reconfigure options, you may do so in ~/.liquidpromptrc.
    EOS
  end

  test do
    liquidprompt = "#{HOMEBREW_PREFIX}/share/liquidprompt"
    output = shell_output("/bin/bash -c '. #{liquidprompt} --no-activate; lp_theme --list'")
    assert_match "default\n", output
  end
end
