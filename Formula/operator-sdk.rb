class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.17.0",
      revision: "0a558d5fc1f6a2be8bcf65dc0e7e02545216591f"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f424aafd4c1199ce46facddfc7f7e3974e0dfc9090c693878b4a3809dcea1287"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a90513b8ec0fe9f0ec940225a4d2f0a75e7b7e490379563665f838425ec47586"
    sha256 cellar: :any_skip_relocation, monterey:       "6fecafd1a6fce33b78dae1a9ff3ad90eacdc704ad1e1efbffdd356efd77ca618"
    sha256 cellar: :any_skip_relocation, big_sur:        "034e78869be0d53a0608ca4ff60c6622e128310ccec7aace55f0f6475494fd50"
    sha256 cellar: :any_skip_relocation, catalina:       "12a5f144b52dd3cf272d4ed881d62ed0e1f6ee53ddc3e6e7c62fdcfb1d4b424d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74709b0f915249b68fb5d1d7177dc79ca2cbd28983047823b1d2e786e8e77106"
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
