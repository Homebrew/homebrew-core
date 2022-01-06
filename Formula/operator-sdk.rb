class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.15.0",
      revision: "f6326e832a8a5e5453d0ad25e86714a0de2c0fc8"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a27af0f2e0780e990ee493539195f0b2be040f83affcc33ca8cb1d1d9324c6d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89876ea6a75442222385f2d93209de1400cf241644a0d82e628c370d9512f4c7"
    sha256 cellar: :any_skip_relocation, monterey:       "e286b168d056d07fe5bccca5c42ce48fb0330cd36135105d1f479578cfc708be"
    sha256 cellar: :any_skip_relocation, big_sur:        "420bca1b9c9aed17d73166693cb9d44693cda7946f6234050b962b6c75c2add1"
    sha256 cellar: :any_skip_relocation, catalina:       "ee3f12cbf59eaeb43b149b9ce4b4314be293474e72aba50c6711eabd54a4e6ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "208e907d28832615d2c7f63e59e65e96fb7ea0cf9fecbbdb91a665207ee7bb02"
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
