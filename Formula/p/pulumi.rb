class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.110.0",
      revision: "e50a7e26ccc0af3183a2cb34ebd1b640dfed4ebc"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fbf7b786cd3ab936db976858112778352cf685d0b4efff5ef3f63a005c38481"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96220aae3fa055016ba5ebf65b07c5e0c708e38159ec2ba7a9d86a99ac484e5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13f06f5c2ad9b56f3f410b633ba3108078c35173f733d277e9a9853bdd76ea40"
    sha256 cellar: :any_skip_relocation, sonoma:         "d23d66da53bbf7612dab3af16b69b4f41ee060af0775a940a0b48f2930042f54"
    sha256 cellar: :any_skip_relocation, ventura:        "03b9fa2010583232c634db8bee8b9661b8087c2ffda08498ab4d0fb4f89a9da3"
    sha256 cellar: :any_skip_relocation, monterey:       "0d2af0530dc23ea48c0d351e373f7f1e3c615721b31dac30b16c3297e3743da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95eaeeac54a7a5c756f9c7ad4c702ebbcf84563c1334fcc349b7f4978964503e"
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
