class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.111.1",
      revision: "c465c02f2979b8a7bb028268df14dfefa3cd89bf"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f08ad3e7358d987fd6746f6fc9d34cbb6c07d4351a2ef4af83a0ef91247ae21f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b448e45cf1b30824aa915735e822f125bda6afc67dbf3452addddcc941db0581"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8473448048bc4dcbc2cd67e7aefd00bd95efb4a06f0708146f69bb042cb7cd5"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a8f6e0d82b575cb05e9fa0b7ccf08175c43f43f4dda2d119138676c214a03c7"
    sha256 cellar: :any_skip_relocation, ventura:        "9780e0979d588010c5a8efe0283e2c46efc07d769682915bc4669d17b51fb7bc"
    sha256 cellar: :any_skip_relocation, monterey:       "8f70ef2fb5b57c0801f7442de7e33dde1cf29e10e14ae9fc4cd0a76da8905f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2602f8e77b6f4de942da799e0ff598e21b40d40f01b858a96ce46145df6c5c5"
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
