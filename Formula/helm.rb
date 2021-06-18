class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.6.1",
      revision: "61d8e8c4a6f95540c15c6a65f36a6dd0a45e7a2f"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7fbaacd5974e34eb482d7e8daf5d7361c7611a0b2800d9d69ee237325c278c1c"
    sha256 cellar: :any_skip_relocation, big_sur:       "79d8c1607e85268a5b8940a1537fef39e838258e74f1fc5033ca45cada755f70"
    sha256 cellar: :any_skip_relocation, catalina:      "132464270967aa216a3e21a27fc8372d1d6b23e1ef9c289dc922512737f00ccd"
    sha256 cellar: :any_skip_relocation, mojave:        "590ed30cc0502d3dee218dda8ca81b565b8aa3f853685468c24d5454563478cd"
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
