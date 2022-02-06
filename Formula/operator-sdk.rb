class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.17.0",
      revision: "704b02a9ba86e85f43edb1b20457859e9eedc6e6"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb905bb19cb31a78b969d7d05dcd1bc8e8123f496c81318ad7ab50fce71d9d4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ba510e0e019b30bc15c2e9ee9d9e75210497c5ff6a96772d0783e4f73ac65c0"
    sha256 cellar: :any_skip_relocation, monterey:       "1abe5db599b295dc2e97e8a61406885d0ca95b3a7340d75197795142149ee794"
    sha256 cellar: :any_skip_relocation, big_sur:        "daa252ea2d46e0882a53c34a915987fa0c35074b95e7b42e73b1cbe10496f6f6"
    sha256 cellar: :any_skip_relocation, catalina:       "ccaf29456a18c8192dcdbc1ddbabb1e9f1f2312d45d3281f6c9eca89efae300a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55f2b34baeab84ff0a852e8127a85cbc239e58b3250e5559520563f1ecd43a85"
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
