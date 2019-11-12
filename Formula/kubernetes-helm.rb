class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      :tag      => "v2.16.1",
      :revision => "bbdfe5e7803a12bbdf97e94cd847859890cf4050"
  head "https://github.com/helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f5cfdfa468951ac2d8a263c4718d4d3ce7b6aecda9acd7c72ea9b45fdbea429" => :catalina
    sha256 "0e67b98e5b0b7b1a12bf2c807ecd362a5fd727efe683ce9cb58c2c07fc9f9cff" => :mojave
    sha256 "1ef513d4f6f7b06dae7d7106be9f3c492539b04306208d231fd76a43e68f88c0" => :high_sierra
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
