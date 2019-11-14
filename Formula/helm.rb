class Helm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      :tag      => "v3.0.0",
      :revision => "e29ce2a54e96cd02ccfce88bee4f58bb6e2a28b6"
  head "https://github.com/helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e13b6d2b1a76b4af452e8582f2d2b07cde2b231de00ce16be04dbbf0c77b49af" => :catalina
    sha256 "e41f332120fc3a047b2b654a6afb286c9a09e24a0ac5929ba943cc94940d1267" => :mojave
    sha256 "29683ee842eaebd7a88c8c1f9e9069c12f6c8c0b531ff9255fe97330da58d2d8" => :high_sierra
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
