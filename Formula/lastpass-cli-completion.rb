class LastpassCliCompletion < Formula
  desc "Bash and Fish LastPass command-line completion"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/archive/v1.2.2.tar.gz"
  sha256 "26c93ae610932139dacaff2e0f916c5628def48bb4129b4099101cf4e6c7c499"
  head "https://github.com/lastpass/lastpass-cli.git"

  bottle :unneeded

  def install
    bash_completion.install "contrib/lpass_bash_completion"
    fish_completion.install "contrib/completions-lpass.fish"
  end
  test do
    assert_match "-F _lpass",
      shell_output("bash -c 'source #{bash_completion}/lpass_bash_completion && complete -p lpass'")
  end
end
