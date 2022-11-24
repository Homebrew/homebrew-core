class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.48.0",
      revision: "189a0eff7c68d3d30a2c0c6e8344a4aa125da871"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43e9153f6ce24a308c545d7661ad279aad0ffa59c428657d8b4a358201e6bf4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc06501756630f26276c1b8695ffc1a7a779dd7ca267a220c0fc63fb505c2acc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b533971df47fbc2134d8fc45cc4e272d0ae64f654a9686a570dffa2969a8945c"
    sha256 cellar: :any_skip_relocation, ventura:        "c61a6deb692c3d068e5ad1818e3d472091e47cec7b5affd8f7997495e2a41f45"
    sha256 cellar: :any_skip_relocation, monterey:       "611bbbce07f099fa244d7c1cd94a450eafde8c01a782cf0337d819cab79fc366"
    sha256 cellar: :any_skip_relocation, big_sur:        "edbfce2d669311c9a285d3989ee845b742afb8ba271e8ad5bed252bf90822ea1"
    sha256 cellar: :any_skip_relocation, catalina:       "04e3b0fd22fcc453e505607cce90cdfa97fadf2bfd80a449e340a1660f0b86d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52c0df15338fa6553d5397b59ea82a1de365979a702f758708a547d9b1c98262"
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
