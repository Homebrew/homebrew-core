class Helm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      :tag      => "v3.1.0",
      :revision => "b29d20baf09943e134c2fa5e1e1cab3bf93315fa"
  head "https://github.com/helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5987c80ea21063f3c26a799889ad3e0b35c73275bd3579e5a1f6785d6f3f43d5" => :catalina
    sha256 "29239b6d467e3ebe810645e45a4635a5e239ee6f1e1bd33d7bfa33e02a79ceae" => :mojave
    sha256 "dd5a05fa985c1a696a5b7db0aa7548e0de31094569558eabc2b2cdc4dac24264" => :high_sierra
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
