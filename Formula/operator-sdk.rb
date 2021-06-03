class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.8.0",
      revision: "d3bd87c6900f70b7df618340e1d63329c7cd651e"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "864267e4c586a03de14a612f604ad0c46d27b96b333f048721ec7cc5af8dc836"
    sha256 cellar: :any_skip_relocation, big_sur:       "c097f8d768bd4ef739d6ef71eabfa5139ea2c6ca114143e182cf2268ddf9a55d"
    sha256 cellar: :any_skip_relocation, catalina:      "4f83d038d343bc16f5ab9b5814247a4a396968f66513215c2ce5e6a9e5090a67"
    sha256 cellar: :any_skip_relocation, mojave:        "2a2eaa53558d93460be9da719bddc034eefd1de14733cd604252725d269256a2"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/operator-sdk", "completion", "bash")
    (bash_completion/"operator-sdk").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/operator-sdk", "completion", "zsh")
    (zsh_completion/"_operator-sdk").write output
  end

  test do
    if build.stable?
      version_output = shell_output("#{bin}/operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      commit_regex = /[a-f0-9]{40}/
      assert_match commit_regex, version_output
    end

    output = shell_output("#{bin}/operator-sdk init --domain=example.com --license apache2 --owner BrewTest 2>&1", 1)
    assert_match "failed to initialize project", output
  end
end
