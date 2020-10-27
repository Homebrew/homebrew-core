class HelmAT2 < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v2.17.0",
      revision: "a690bad98af45b015bd3da1a41f6218b1a451dbe"
  license "Apache-2.0"

  # NOTE: Remove this livecheck block after deprecation takes effect, so we
  # don't unnecessarily check for updates.
  livecheck do
    url :stable
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f842166eae515ed30c9f91c0ad27994640332b889fb490c2fe2f4ef818501dac" => :catalina
    sha256 "edc42658f135c42ca81df5a05184b209fd26e2ad78c93583646a219dbd33cbd5" => :mojave
    sha256 "bf0f6e9a6a3d40e03b76f551bf88d6b2f81f825f063a139c90f804c56b94f885" => :high_sierra
  end

  keg_only :versioned_formula

  # See: https://helm.sh/blog/helm-v2-deprecation-timeline/
  deprecate! date: "2020-11-13", because: :deprecated_upstream

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

      output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"helm", "completion", "bash")
      (bash_completion/"helm").write output

      output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"helm", "completion", "zsh")
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
