class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/kubernetes/helm.git",
      :tag => "v2.2.3",
      :revision => "1402a4d6ec9fb349e17b912e32fe259ca21181e3"
  head "https://github.com/kubernetes/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df4ca14688105118d77281dd23a30198b2491f510bea8aa05ce0026fc6c7d745" => :sierra
    sha256 "e6c697f33a299ca293db4c81232a96ab5e52ea08eb839dd80578601019029e1d" => :el_capitan
    sha256 "6d521c604d9860d00bd7d0c55ee1f7590a63af9e9e1d5b8b6ef3b1766ed62c04" => :yosemite
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

      # Install bash completion
      bash_completion.install "scripts/completions.bash" => "helm"
    end
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory? "#{testpath}/foo/charts"

    version_output = shell_output("#{bin}/helm version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
  end
end
