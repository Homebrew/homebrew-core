class LaunchctlCompletion < Formula
  desc "Bash completion for Launchctl"
  homepage "https://github.com/CamJN/launchctl-completion"
  url "https://github.com/CamJN/launchctl-completion/archive/refs/tags/v1.0.tar.gz"
  sha256 "b21c39031fa41576d695720b295dce57358c320964f25d19a427798d0f0df7a0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2a7e390f88b9c9af6385e775f96d855d40ebe4bf821a3f14de9903d8f30bad7c"
  end

  def install
    bash_completion.install "launchctl-completion.sh" => "launchctl"
  end

  test do
    assert_match "-F _launchctl",
                 shell_output("bash -c 'source #{bash_completion}/launchctl && complete -p launchctl'")
  end
end
