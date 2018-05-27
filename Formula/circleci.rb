class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  url "https://github.com/circleci/local-cli/releases/download/v0.0.4705-deba4df/circleci_v0.0.4705-deba4df.tar.gz"
  version "0.0.4705-deba4df"
  sha256 "0c2b76afc04f3883ad46aa095509749faed3d7ae392fe54399aba60e6721f4a3"

  bottle :unneeded

  depends_on "docker"

  def install
    bin.install "circleci.sh" => "circleci"
  end

  test do
    # assert basic script execution
    assert_match version.to_s, shell_output("#{bin}/circleci --version")
    # assert script fails for missing docker (docker not on homebrew CI servers)
    output = shell_output("#{bin}/circleci config validate 2>&1", 1)
    assert_match "Is the docker daemon running", output
  end
end
