class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/kubernetes/helm.git",
      :tag => "v2.5.1",
      :revision => "7cf31e8d9a026287041bae077b09165be247ae66"
  head "https://github.com/kubernetes/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9210f647404f11ba0f4b6eb4b9723de0ce3c005a301732cfd3ad6e35504aa69e" => :sierra
    sha256 "88084b5f890ecd0da9306aea1e840ca274f10e9054a617ec027b807f44cdbb26" => :el_capitan
    sha256 "01bd3eedfbed2600f05a5733c21bad6cd4f8965dc55d9f08026fffa2f89fcc20" => :yosemite
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
      # Bootstap build
      system "make", "bootstrap"

      # Make binary
      system "make", "build"
      bin.install "bin/helm"
      bin.install "bin/tiller"

      # Install man pages
      man1.install Dir["docs/man/man1/*"]

      # Install bash completion
      bash_completion.install "scripts/completions.bash" => "helm"
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
