class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.12.0",
      revision: "d3b2761afdb78f629a7eaf4461b0fb8ae3b02860"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fbf829066a9367124d5ca2f8608d08b3c5232a60f1c86604543e456bd458846a"
    sha256 cellar: :any_skip_relocation, big_sur:       "0843e544a5aff2813c34308dfcf31b3776fc1a48ac0438541caba441411fc5f0"
    sha256 cellar: :any_skip_relocation, catalina:      "f803282b943e2a55a210d7138363d150a34ad83e96332d2378efdc49c34268ae"
    sha256 cellar: :any_skip_relocation, mojave:        "0b301b84823537a14bb080753598800e7e292b80f9f5e7a0f21fb63eee864822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5566f30455036dd0ec2a147c715974fb7e0104c655c3866cdd918019580a49b3"
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
