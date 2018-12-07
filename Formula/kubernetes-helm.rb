class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      :tag      => "v2.12.0",
      :revision => "d325d2a9c179b33af1a024cdb5a4472b6288016a"
  head "https://github.com/helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "74bfbc75ed551ba51124d1b088f45df642a55d9d9fdef45d796d690f70c1f10e" => :mojave
    sha256 "a590fd6a017b39a10697206e858512dd73422f42fd6e653ed6817c9a4aee6929" => :high_sierra
    sha256 "4747d26dd48bcb3adbc8a333fb5a323460c4f40592b7d4095db7a83ade727b2a" => :sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "mercurial" => :build

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
