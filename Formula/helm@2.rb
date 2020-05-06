class HelmAT2 < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      :tag      => "v2.16.7",
      :revision => "5f2584fd3d35552c4af26036f0c464191287986b"

  bottle do
    cellar :any_skip_relocation
    sha256 "a79372b352e805f380963d712dc9cf29b86fca6b12508d09dabaa93deed9e094" => :catalina
    sha256 "53b3e9f51b9375a178d87de534b3a76a2c1956a152f11a98a6a1974d323e6e43" => :mojave
    sha256 "079f8ae57d1d301f2e59ea418f929b0597e683ca536ed54032fba3f70a7dbd52" => :high_sierra
  end

  keg_only :versioned_formula

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
    if build.stable?
      assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output
    end
  end
end
