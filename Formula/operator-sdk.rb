class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.3.0",
      revision: "1abf57985b43bf6a59dcd18147b3c574fa57d3f6"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "085720eb4fb2bfafd0475119ed704cadc62390e63829ea86337b4e5e763999f2" => :big_sur
    sha256 "1f5b6fc68245da7464e5ba868ec8e907a362def193c0339b2e44388c44fa3dc2" => :arm64_big_sur
    sha256 "8f65a0a7cb191314734b0eee3188e90d5c9f0f6441c7b103acbca01c51b67402" => :catalina
    sha256 "ae6df2e3c3f970f3b0ca807c597cb3a9a08fdf8bca1515c723fef6b588686645" => :mojave
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
      assert_match Utils.git_head.to_s, version_output
    end

    output = shell_output("#{bin}/operator-sdk init --domain=example.com --license apache2 --owner BrewTest 2>&1", 1)
    assert_match "failed to initialize project", output
  end
end
