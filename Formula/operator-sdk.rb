class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.6.2",
      revision: "b131ca8ec77c96b9898470eba9560c30af0f23f3"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2624193d1a76ece58307fc0532af0434e2f052a9ad8a3ab6ad25245dcadc0a6f"
    sha256 cellar: :any_skip_relocation, big_sur:       "2a9b646cfd95e1f5f5fa79be1e36166b16c332336f6e5fb88af25926b3deed7c"
    sha256 cellar: :any_skip_relocation, catalina:      "3ddfffcf30fb489d6d819c840c0a015a8fb49379c89402040e6f10400353ad91"
    sha256 cellar: :any_skip_relocation, mojave:        "c30655276446c99e07c4e09f0084e64ecdb189f4715ffd1a0ca0a15e68cd8de2"
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
