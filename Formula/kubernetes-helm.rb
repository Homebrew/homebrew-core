class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/kubernetes/helm.git",
      :tag => "v2.6.2",
      :revision => "be3ae4ea91b2960be98c07e8f73754e67e87963c"
  head "https://github.com/kubernetes/helm.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "aac5cf956ff8335631c6ceda8d787012ddf971340bc538983f0b55cc2bcb027a" => :high_sierra
    sha256 "382374df1198717d8b65fafad34e666408f31b173f2a2e526e45f417bb6378cf" => :sierra
    sha256 "bf56fb083e391dec55b33da32e6537a9ad273610d20f0cf564560579f966ebbc" => :el_capitan
  end

  depends_on :hg => :build
  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    ENV["TARGETS"] = "darwin/#{arch}"
    dir = buildpath/"src/k8s.io/helm"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "bootstrap"
      system "make", "build"

      bin.install "bin/helm"
      bin.install "bin/tiller"
      man1.install Dir["docs/man/man1/*"]
      bash_completion.install "scripts/completions.bash" => "helm"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory? "#{testpath}/foo/charts"

    version_output = shell_output("#{bin}/helm version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output if build.stable?
  end
end
