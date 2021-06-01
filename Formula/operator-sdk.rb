class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.8.0",
      revision: "d3bd87c6900f70b7df618340e1d63329c7cd651e"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "02c8e5496e2170ee48b3edd85250efe6ee74e29bfac6851f6ee91c9a1cfc6fd9"
    sha256 cellar: :any_skip_relocation, big_sur:       "e08d2dc21573f33febbe11ab5cb7b3efd0146770b2dd1215113a101204fabff9"
    sha256 cellar: :any_skip_relocation, catalina:      "64b5db0a220d235fb52cb222121c18100aa63fe721a46c005893acced4a580fa"
    sha256 cellar: :any_skip_relocation, mojave:        "264bd5eb11ace894a48820e060787d2c9facd8160c0267b18ebf825351efce27"
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
