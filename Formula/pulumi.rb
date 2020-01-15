class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v1.8.1",
      :revision => "7b9e05eb6a0262b3750e1c8405c4808b449cfe1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f54c9c65a8b6a770c66a2b4a2e4b0891516ffb9c60302ee6660226ce9a72fba1" => :catalina
    sha256 "76c07ab883b423b9420e1dd9c57733fce0add95a2bd1d4e19fb672a889ce2be6" => :mojave
    sha256 "9d1c41b7ec6d63b8ebf1b9e9dd82c035773bf7bb90b5f67358367cdd5e6c9850" => :high_sierra
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
