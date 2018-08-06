class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  url "https://github.com/circleci/local-cli/releases/download/v0.1.0/circleci_v0.1.0.tar.gz"
  sha256 "e6b86954c8ccb38ca16b77cfcd642a1be20c9fa471ed811c49f7105bcb96739c"

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
