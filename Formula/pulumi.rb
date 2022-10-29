class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.44.3",
      revision: "2710691c00cdc3e059c6acd607c03b8b818fac90"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0cdc09d4986991379bee0924e9b16c83dec87794af36183e8e985c3f2bc820a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d291d6d8d099da8d1a399e8173ad2617072f4afa4a259970600b99668c4e249"
    sha256 cellar: :any_skip_relocation, monterey:       "4d56e5047d2da40835a784eeda4b66bde23b4ff9f8095e74537af6d4e7a476f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "19d0ef48d02c0164049dfd2df51c61a325b8337f680c4b34877ab6acbc8bf604"
    sha256 cellar: :any_skip_relocation, catalina:       "5c71cc49400becca45a503c81c2bb64eecb8b6eb0c45c3df5d5e5441de480a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c57b35cb22cac450c588699ab735aed061cf991718740077f68022f1869f5556"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
