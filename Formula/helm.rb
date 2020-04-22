class Helm < Formula
  desc "The Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      :tag      => "v3.2.0",
      :revision => "e11b7ce3b12db2941e90399e874513fbd24bcb71"
  head "https://github.com/helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9204dc532c352ea7cb1a05d8d9d0cdfd8f6ef0f35638c0bb3e3513f19a41abf0" => :catalina
    sha256 "d1357b2635d0fb7cd9b4f4bc75236e7e6de4de18255d8eaf870353bdd29d2453" => :mojave
    sha256 "508018eceefe9a91ecbd0be678ddac8d12699c52864ae698f7b1354e6498f04a" => :high_sierra
  end

  depends_on "go@1.13" => :build

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
    if build.stable?
      assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output
    end
  end
end
