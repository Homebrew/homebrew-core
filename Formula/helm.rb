class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.5.2",
      revision: "167aac70832d3a384f65f9745335e9fb40169dc2"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0bbe8d4d4fa8ab34e48962517fd16c78a2373e08b929243e13b76745afddcf75"
    sha256 cellar: :any_skip_relocation, big_sur:       "8f7fd5769848ce05848f8008b3b41cb2326829e861e2d9e22c8dadd09a26ac13"
    sha256 cellar: :any_skip_relocation, catalina:      "1cb4e2c9f990414039240b8364cc5e1718cd85bc9ab1e4ed5e609ef931195fd9"
    sha256 cellar: :any_skip_relocation, mojave:        "00ffb8f69d4d0e1f3bd876a38ab2c9444b93cac330a83051f0b9ed0cae098170"
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
