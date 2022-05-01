class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.20.0",
      revision: "deb3531ae20a5805b7ee30b71f13792b80bd49b1"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37a225cca2d7a611824d2544d440eb982b313aa9d3f1547407f2316fd672aa65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccbd7d917a37b63e36baca9e1c0b1c106eed2376f676a07706180b1ad19f3fa0"
    sha256 cellar: :any_skip_relocation, monterey:       "98f5f30c34136b59128d7d785a5ff32a2c07803e07f3851bed94889d9612f115"
    sha256 cellar: :any_skip_relocation, big_sur:        "90c0de4ecb1c1728d26b9907c060a12d201f9cd29659db4c2084cf8846fc227d"
    sha256 cellar: :any_skip_relocation, catalina:       "dd750c81004c11f88af6d05550eda0811d9566fa5d7dfd36bf48baac16539860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b951111c79c494c2e3a4ea06562306d698959a6807b002132c578cca64ad75eb"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"operator-sdk", "completion", "bash")
    (bash_completion/"operator-sdk").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"operator-sdk", "completion", "zsh")
    (zsh_completion/"_operator-sdk").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"operator-sdk", "completion", "fish")
    (fish_completion/"operator-sdk.fish").write output
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
