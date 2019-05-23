class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v0.17.13",
      :revision => "61bff0c3a4c1b230fb07bf1a4fe32b3c9027d2ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "c323d063904dc5921ab7f80451f89f4fe6d3ec9fb616669906876a85bba9f062" => :mojave
    sha256 "4c3dc1283c3dabccfef22ba4e5fae7d8389d2a0db6d9edd2e6a4d4833f212b69" => :high_sierra
    sha256 "256e25dc2805a9954f7d3b3db9690dbdfab5c7e8f3156aa42bad6172ecb58ef0" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/pulumi/pulumi"
    dir.install buildpath.children

    cd dir do
      system "go", "mod", "vendor"
      system "make", "dist"
      bin.install Dir["#{buildpath}/bin/*"]
      prefix.install_metafiles

      # Install bash completion
      output = Utils.popen_read("#{bin}/pulumi gen-completion bash")
      (bash_completion/"pulumi").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/pulumi gen-completion zsh")
      (zsh_completion/"_pulumi").write output
    end
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
