class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.18.1",
      revision: "707240f006ecfc0bc86e5c21f6874d302992d598"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6df7b51695d5e7f5f6e5899ae03c753461d819378d640ea32d64836b4a76e45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d9ba3d9c6105d32d7231d90f4a96bc95b5b6addf8db640ea849ae31637bd391"
    sha256 cellar: :any_skip_relocation, monterey:       "8d23c3c4351308671358b722a2be0c331e3bdec56446de9b163e211bbe34c045"
    sha256 cellar: :any_skip_relocation, big_sur:        "40062d22fa65727634dfe2de82a6b92a0a6878b8341d2f66bf0c7fa3adfee833"
    sha256 cellar: :any_skip_relocation, catalina:       "a2b33d5e6a30266afd8f64a9162c16787ee2c95d7135d23a4f8a381cf84dc223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af68385551bb3a265cbe3aa57c4e5f84a24ab9be1eeee764aa5f68d5e1d1c1e5"
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
