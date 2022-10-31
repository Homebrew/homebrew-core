class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.45.0",
      revision: "6a74bc1abbfbae096c415262527124e900e81711"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0756503c64118537fa983888edc8f113dc07420b28e9f656a275a15ffa1f1cff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "856414131a61dc567de815f0a3296c7577577e666e9c7d2df4d43cb98b417e96"
    sha256 cellar: :any_skip_relocation, monterey:       "8afbdf4c4b9f83ca2ab4071f88d801e54e835ecc355e36ee24e57a3c650cdeff"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ab725b6fea4871fe284fc050dd75d4c53ade1136532af78111075175739e1a7"
    sha256 cellar: :any_skip_relocation, catalina:       "fc021a6f5e1ba44331ecc68602eca3a9dede8460d49d5c11e55ab74cc833695a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfa4c0240a893b7a73896cd4e7465b54644cfb3a54e4e04ff08e58d1a103bdbc"
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
