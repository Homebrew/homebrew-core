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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1614b88c3da2046baae1affa0d4bcf0188b31932cce3de487cd95256aae47910"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29f3b57765feed6d239fd7e648791f8ba56078c93216f51958edeba27665fa6b"
    sha256 cellar: :any_skip_relocation, monterey:       "2ec706b7271b8040982fe171a50106e7cdde9eb6478ef3282df60a4f23191876"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bf8ece0fab9790340759784ef3e5c8ae018bdaa9ebfbec21c3092df1e143964"
    sha256 cellar: :any_skip_relocation, catalina:       "068d3942e60a7350cd18347f6c2dbab045941ecebfd91baa3727c6bbb2b0630c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1a21f88b6200405804fd3b4c4e8fdf7c77172682a0a74374fa132ac82360322"
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
