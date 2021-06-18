class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.9.0",
      revision: "205e0a0c2df0715d133fbe2741db382c9c75a341"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7753c89b28be3f280993e909907d08632ed9e4147aa1a38e85739506247447a4"
    sha256 cellar: :any_skip_relocation, big_sur:       "1cfd057ae7b5f46f3d1ee105f4cb86f8f9a207b024f62711c292558f74217ddb"
    sha256 cellar: :any_skip_relocation, catalina:      "3e34fd9cb1e28cec737808888b84ce8a16b29291469741b0902ce7baa9beff63"
    sha256 cellar: :any_skip_relocation, mojave:        "475802da75f871cfdfccef6dadbe2db26b7594363982cb5775dd6edf80955816"
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
