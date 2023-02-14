class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.55.0",
      revision: "36f4b18721e7c9b5dc4e12e10d02bc7cd023b9c8"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37503b8b4c8f451ada5ad3618a6d20a3fda59a5bfc504b5c15e80e4442d8dda2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1964616e0ca10b2ca46b8c08c2f226bd4e3a3c5af8da7f517af78288cac9db5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0893410d4ef58927a4f5f6bdc995f9abaa1c5889e9fb530a06ae394fd1e2d72"
    sha256 cellar: :any_skip_relocation, ventura:        "83168d7a6c9008add4e3928d514446c57a7fb6fbc4b7fe7bde0516aa5a0049af"
    sha256 cellar: :any_skip_relocation, monterey:       "dd18891a5f108e482ed3d22ebbb156da1b47a3b41d74044504903b835fbe0b4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c68fc969fd3f7b2a15d22c8fd94eca3c09d18bdead1289c6dac4d5f2d5afa287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca7058e3997cb9adf2e7ded99c0107c74a33c10e99c0e0545685123161aa6b8c"
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
