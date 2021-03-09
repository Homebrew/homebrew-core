class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.4.2",
      revision: "4b083393be65589358b3e0416573df04f4ae8d9b"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dab80dcd711963920fa09a2d174fcece5867bfb42ebac36c20775868094e88ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "41d8b868d0948f9f9907d81c14027b2663c14efd89554a641c16011d690f6ea8"
    sha256 cellar: :any_skip_relocation, catalina:      "d65c80958e7989176778c3b4166b8215453e250c29bbc0ceb1e7e45ab0115665"
    sha256 cellar: :any_skip_relocation, mojave:        "5da1694af236ca0422dc097d6b8982419d052e4ca3d4247578a5935420170e46"
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
