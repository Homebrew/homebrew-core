class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      :tag      => "v2.14.3",
      :revision => "0e7f3b6637f7af8fcfddb3d2941fcc7cbebb0085"
  head "https://github.com/helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35424b638f34e451a572959e2548c97a18589a97e997053f4c25e39511e17ac8" => :mojave
    sha256 "b0dabf5935ba18efd9c247f75b8b50efcdb34e6f2d74bc8ccb781bc78ca612c3" => :high_sierra
    sha256 "4e43a2e5ca35248314a84d9e791de028a9634b7060ecb6188192f59e7010faec" => :sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    ENV["TARGETS"] = "darwin/amd64"
    dir = buildpath/"src/k8s.io/helm"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "bootstrap"
      system "make", "build"

      bin.install "bin/helm"
      bin.install "bin/tiller"
      man1.install Dir["docs/man/man1/*"]

      output = Utils.popen_read("SHELL=bash #{bin}/helm completion bash")
      (bash_completion/"helm").write output

      output = Utils.popen_read("SHELL=zsh #{bin}/helm completion zsh")
      (zsh_completion/"_helm").write output

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
