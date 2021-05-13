class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.7.2",
      revision: "6db9787d4e9ff63f344e23bfa387133112bda56b"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "91d0d20be4ed36807478fd1326d607e1e83c2095776859f5b2869cc91de01dd9"
    sha256 cellar: :any_skip_relocation, big_sur:       "9577c43f6ff3a5bfdbb929137bfeac820ef75579d40db67505a779a480c51985"
    sha256 cellar: :any_skip_relocation, catalina:      "8643768ce00b196a010017f35b2cbf66df28723f2bf332987aff9dcf42ae5f46"
    sha256 cellar: :any_skip_relocation, mojave:        "eb5f793df3bde5fb288547d98f1e76ec69bae51eea11389cb8d46bf416fe76e6"
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
