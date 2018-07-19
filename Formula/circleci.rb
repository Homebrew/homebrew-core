class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  url "https://github.com/circleci/local-cli/releases/download/v0.0.4705-deba4df/circleci_v0.0.4705-deba4df.tar.gz"
  version "0.0.4705-deba4df"
  sha256 "0c2b76afc04f3883ad46aa095509749faed3d7ae392fe54399aba60e6721f4a3"

  bottle :unneeded

  def install
    bin.install "circleci.sh" => "circleci"
    ohai "A valid docker executable is required for circleci to properly run."
    ohai "If you don't already have docker, please install Docker for Mac:"
    ohai "Option 1: `brew cask install docker`"
    ohai "Option 2: via https://docs.docker.com/docker-for-mac/install/"
  end

  test do
    # assert basic script execution
    assert_match version.to_s, shell_output("#{bin}/circleci --version")
    # assert script fails for missing docker (docker not on homebrew CI servers)
    output = shell_output("#{bin}/circleci config validate 2>&1", 1)
    assert_match "Is the docker daemon running", output
  end
end
