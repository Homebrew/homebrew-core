class Helm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      :tag      => "v3.2.4",
      :revision => "0ad800ef43d3b826f31a5ad8dfbb4fe05d143688"
  revision 1
  head "https://github.com/helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e78753400abf0cb0cb71af8b1e16217d26c703e020e075d4a95b563dd7cb4a4e" => :catalina
    sha256 "a3c27f74fa2422412c276c98a6dc62b6e746e0c569bfceed74cd0b7c75939c5d" => :mojave
    sha256 "a390ab2d2b29e7cb7a214ea7983f8c37b659a9c90b71988f6c7754455b49a65f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    output = Utils.safe_popen_read("SHELL=bash #{bin}/helm completion bash")
    (bash_completion/"helm").write output

    output = Utils.safe_popen_read("SHELL=zsh #{bin}/helm completion zsh")
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
