class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.11.0",
      revision: "28dcd12a776d8a8ff597e1d8527b08792e7312fd"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9275b1560e3f96436dba56e41f5ee10e857c41087bef229f2e9af52a87ea71c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "b93a3d7feae8da723f49a82480d8b37473c87759c6b0c3221519dd5ab9974f38"
    sha256 cellar: :any_skip_relocation, catalina:      "6658ca42f6b7f03fe5e9f0293b8cc3e491c1acda6d5110f3de82f472e25842c5"
    sha256 cellar: :any_skip_relocation, mojave:        "5ecf7ad4e533ed5852e50c9eb89f1f93432eee0010d36346f6741881b7a456fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98e2b3a5969167bd4d47a761900cba8b6266e6f2e6a68449c975a9b16dff912e"
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
