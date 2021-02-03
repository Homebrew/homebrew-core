class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.5.1",
      revision: "32c22239423b3b4ba6706d450bd044baffdcf9e6"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c5a0b9b201db458443dc612a3363359a5bf29e6b1c740cdd9f4e6721431abb1f"
    sha256 cellar: :any_skip_relocation, big_sur:       "13099f8ea136ba61b09dd6c12f00dcc31a921b3b33ffc655f0eccf00ea4c7cbd"
    sha256 cellar: :any_skip_relocation, catalina:      "4e1166dfdc906d762639e65c8095e7515b0c292ba211ea5280e653542fc00408"
    sha256 cellar: :any_skip_relocation, mojave:        "19bdd62cf4bac0f2cfa069f8fa1f17930812042f33e50f263fce7372201a1862"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"helm", "completion", "bash")
    (bash_completion/"helm").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"helm", "completion", "zsh")
    (zsh_completion/"_helm").write output
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory? "#{testpath}/foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "Version:\"v#{version}\"", version_output
    if build.stable?
      assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output
    end
  end
end
