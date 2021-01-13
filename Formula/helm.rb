class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.5.0",
      revision: "32c22239423b3b4ba6706d450bd044baffdcf9e6"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "28c8ecbcd4d30606e2655564ee15c0599bcd0026ba849323ceed1b1b1714f527" => :big_sur
    sha256 "85b6e29ff493f9631966b109c0a0a33c5730c76ee2a921864e59c4effc0d1701" => :arm64_big_sur
    sha256 "71a2d4c8befae485288013962330bf7c7f8360f15aa83859509929744f333821" => :catalina
    sha256 "fb1eae1b5e6c7b5e2886bad3057fd3fe36d4238dd5f9a55ed54aff2904c1f150" => :mojave
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
