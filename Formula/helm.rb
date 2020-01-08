class Helm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      :tag      => "v3.0.2",
      :revision => "19e47ee3283ae98139d98460de796c1be1e3975f"
  head "https://github.com/helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63bac723db6c01086344a501271103c8b0eae117b13b9cb720efa31eb62285fe" => :catalina
    sha256 "db27b9535d67a9de4f8e0667764d2d75c1917545a04fa0aa2dc6281123fdf90b" => :mojave
    sha256 "18c358c890202edd6cd15ee8f59c015177b932fd536c6421cc7e68be35270a9b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV.prepend_create_path "PATH", buildpath/"bin"
    ENV["TARGETS"] = "darwin/amd64"
    dir = buildpath/"src/helm.sh/helm"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "build"

      bin.install "bin/helm"
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

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output if build.stable?
  end
end
