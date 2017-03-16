class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/kubernetes/helm.git",
      :tag => "v2.2.3",
      :revision => "1402a4d6ec9fb349e17b912e32fe259ca21181e3"
  head "https://github.com/kubernetes/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d219802a01f4f6f45bf11506a03e0b78f89c7c4f280149a535ab4376ead0cbf" => :sierra
    sha256 "2c980fb59b1a84f1f145d369b500bdf3e85df5394d1d937615bf041c04f69b59" => :el_capitan
    sha256 "7c7ad7606ba3e279bfe8601f724b2f550b27a8b7001f68cb192452beaba8ad1f" => :yosemite
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
