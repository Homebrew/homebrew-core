class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.99.0",
      revision: "c94390112a09be069c6b1e77eb54f577103b784c"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5440fc702cddc6968d9953d3b74c553e249dac71e0ceecab84568b85a797d847"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e4d8aab74be8714998e2c60163dad127ab761815631a5960727c4f3421cfc0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3be82429b5bb254aae55fda3377745da12f667d64d1c9f4959fd9036a252d5eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "71e0758ff88c23a2692c0a6c04c26090485f2a2a103a62ec690ac3d9655529a4"
    sha256 cellar: :any_skip_relocation, ventura:        "733427549bc91d4e3e6ebf6b676c42cee5575655e2378a6527f10a220f4a8d22"
    sha256 cellar: :any_skip_relocation, monterey:       "965cd724904fec18b433665ace9e41629fbb9d2577134147a3ecadf710b166d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79da5e4605382751c6c49da6eb4151bf135f5016789448f1dcc1dcdb8aa7affe"
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
