class LaunchctlCompletion < Formula
  desc "Bash completion for Launchctl"
  homepage "https://github.com/CamJN/launchctl-completion"
  url "https://github.com/CamJN/launchctl-completion/archive/refs/tags/v2.0.tar.gz"
  sha256 "990499494562cedf361482c5bf9f89b3a8b6a8aee92fda4e1eadaacb96688ecd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb5ad864a24035baedca788946f7d39c9d7da36e5a14ab43abf26544ef753e0d"
  end

  def install
    bash_completion.install "launchctl-completion.sh" => "launchctl"
  end

  test do
    assert_match "-F _launchctl",
                 shell_output("bash -c 'source #{bash_completion}/launchctl && complete -p launchctl'")
  end
end
