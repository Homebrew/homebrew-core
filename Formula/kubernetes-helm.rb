class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/kubernetes/helm.git",
      :tag => "v2.2.2",
      :revision => "1b330722aafcb8123114ae51f69d1e884a326f3e"
  head "https://github.com/kubernetes/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "94042f2d3500fbdd30a7bd2a185371d1f168db56868c726a517974f086985977" => :sierra
    sha256 "81ec0b2f251577a35ec40e379faae91b34234abf2ba9be52b1a5c3686a5fec47" => :el_capitan
    sha256 "282cba29d67466e8823b988463df76685bc1274843f47f9ab078e46e5fa9bc40" => :yosemite
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
      # Set git config to follow redirects
      # Change in behavior in git: https://github.com/git/git/commit/50d3413740d1da599cdc0106e6e916741394cc98
      # Upstream issue: https://github.com/niemeyer/gopkg/issues/50
      system "git", "config", "--global", "http.https://gopkg.in.followRedirects", "true"

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
