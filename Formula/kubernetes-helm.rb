class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/kubernetes/helm.git",
      :tag => "v2.1.3",
      :revision => "5cbc48fb305ca4bf68c26eb8d2a7eb363227e973"
  head "https://github.com/kubernetes/helm.git"

  bottle do
    sha256 "811c2cabac0420f5eb4608a194ddc3e96196c988b95387e0cdbe441a3f52459d" => :sierra
    sha256 "3914aa33e47b34b844f82da5032696f25cf55cf40147bd318329b1a3370c89e5" => :el_capitan
    sha256 "14ad01505b1a598b941422a4d8120ba0e3074430f18c3e1b1b38bccef3938b98" => :yosemite
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
