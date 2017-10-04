class KubernetesHelm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/kubernetes/helm.git",
      :tag => "v2.6.2",
      :revision => "be3ae4ea91b2960be98c07e8f73754e67e87963c"
  head "https://github.com/kubernetes/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a030c0ea9f980cdd4523b4cab0f013bec529ce6225117492c55a924871163bb7" => :high_sierra
    sha256 "aac19ad1d1d3ff9c015b7f7556a8e8cd12bf0807ac8e2e8c915513a89c3b2477" => :sierra
    sha256 "49b6eca7c0dc1d77f496c8e616da32f53fb13eafbdfd49a499bb259543cd6f15" => :el_capitan
    sha256 "f364169da5dee273b9a05fbb77cbd0a9fa508508edcbea224311a69754648e95" => :yosemite
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
