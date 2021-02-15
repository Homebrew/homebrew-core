class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.4.2",
      revision: "4b083393be65589358b3e0416573df04f4ae8d9b"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    sha256 arm64_big_sur: "775b47ec7acfe939129e2e9ac074f606fc8c83743fe7ec2504563f414a1ff8c0"
    sha256 big_sur:       "41b96e62890690976ca737125507d72ce95c2f831b86f9353103f975ec97a2da"
    sha256 catalina:      "2cc1f2a5a8e0c831235145bbaf78c3534d755cc1d2b1a0d0b882aa1525c5d6c2"
    sha256 mojave:        "ebaaef06b386c0336adb2b8f7cbcab7540eeed106c78002dcc1555f86425854b"
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
