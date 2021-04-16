class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.5.4",
      revision: "1b5edb69df3d3a08df77c9902dc17af864ff05d1"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d6f4109759e44e84ef71053a5346739b30b05eb43eedc3d811d729c893c1bb85"
    sha256 cellar: :any_skip_relocation, big_sur:       "5dac5803c1ad2db3a91b0928fc472aaf80a48821a0293fea78f392a5c604772b"
    sha256 cellar: :any_skip_relocation, catalina:      "4462d2d90ea756ae5fcaa3550053542748678baf91a74ee9e26e5e101c3389c7"
    sha256 cellar: :any_skip_relocation, mojave:        "abe29810ff4a9099ef48fbc240b5b4b06359d7422efd66418b2c82682367fccc"
  end

  depends_on "go" => :build

  def install
    # See https://github.com/helm/helm/pull/9486, remove with next release (3.5.4)
    on_linux do
      system "go", "mod", "tidy"
    end

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
