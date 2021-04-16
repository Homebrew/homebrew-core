class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.5.0",
      revision: "98f30d59ade2d911a7a8c76f0169a7de0dec37a0"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfbb540e7ace32511ffdd4afa27f497c398408c1dc0cadb10e9e954cc5c1a710"
    sha256 cellar: :any_skip_relocation, big_sur:       "7f65de9e688f5d5f96fb53485e4ba22c0d39ac1e7b20377012b2de3d8c9c1223"
    sha256 cellar: :any_skip_relocation, catalina:      "0deb5ca0aec5983fd5eb0c846503e436d46fe89b484a80583934d63ad2605ae4"
    sha256 cellar: :any_skip_relocation, mojave:        "e20a53867394681fff6391dec9b1e59975be9484f60f357fe26a4f89e29126ac"
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
