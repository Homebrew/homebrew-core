class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.10.1",
      revision: "5b69c2803890aa841fb361a4b9526dd251fe02e6"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "845397db308042173fe20ebac12e88b9e0e8994fac1914f9368f58b77c6ed26d"
    sha256 cellar: :any_skip_relocation, big_sur:       "e69a9fa62c5d44767cf19bd65dd018c91d5bdfa8861b88fcf9be8fd17019c11e"
    sha256 cellar: :any_skip_relocation, catalina:      "7a679a5baa50ca55b9483e9db4f7f2f90d8d3b9589849004c8aafccc3c865f2d"
    sha256 cellar: :any_skip_relocation, mojave:        "dd19cfc4079d489bc5068505a7b3c707d6c28657108d6543c4e98392f93e9ca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7ea73540de08aa37bc6dc97ce02445c6ec383692a8238647abf061e90ceea29"
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
