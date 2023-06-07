class LaunchctlCompletion < Formula
  desc "Bash completion for Launchctl"
  homepage "https://github.com/CamJN/launchctl-completion"
  url "https://github.com/CamJN/launchctl-completion/archive/v1.0.tar.gz"
  sha256 "b21c39031fa41576d695720b295dce57358c320964f25d19a427798d0f0df7a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "14ff31532b6b8df8c32ffaad844a0a7fa5d1d12b0fc9df3f3497bb4a38b67945"
  end

  def install
    bash_completion.install "launchctl-completion.sh" => "launchctl"
  end

  test do
    assert_match "-F _launchctl",
                 shell_output("bash -c 'source #{bash_completion}/launchctl && complete -p launchctl'")
  end
end
