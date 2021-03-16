class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.5.3",
      revision: "041ce5a2c17a58be0fcd5f5e16fb3e7e95fea622"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "74f08b7e0da6b0ec03769217c274dd5aa5efe7cfcfdcc19dfba77b90634d0fde"
    sha256 cellar: :any_skip_relocation, big_sur:       "69ed70c1f6153c5f0e812ca74b48bb9a07d72d979ae7e65a0b8f8f98ae341708"
    sha256 cellar: :any_skip_relocation, catalina:      "9f61af6cb13b36437172ee7fb014d947c648d6fcc5bbf438a6393a23a757d64d"
    sha256 cellar: :any_skip_relocation, mojave:        "cbf6b54599ce1575e7661170ffb5bc6385ad0a4c23d9efe466fda75f16be4883"
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
