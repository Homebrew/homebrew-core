class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.19.0",
      revision: "728682c347f6335ee2a610e08790a5e1411508f4"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "126752e808f4a272dbe47885bcbbcbf0decb04839ad7f23eea37a4a47831c22d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8c2e7c31d367f0d9b1f75b9b9df7705ee83ebefff0fc7958883b35355bbd767"
    sha256 cellar: :any_skip_relocation, monterey:       "6669b27cedf47db96d8248e0b50e1c3d321a9900c102cc8c4d906a1aff72b943"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bf7cfd8e612e653e0db29f63dd31d807362636f44d1ec9ff5f40c3ecb33fb95"
    sha256 cellar: :any_skip_relocation, catalina:       "363ac9f1b135bfec0c2d1e332e82c2772634b64fe4ba22321bdfe19f7abdf6d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "062066f60ef5b36f99a83ed7c21d6606383f54bcce8675ac32d5ef320825f234"
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
