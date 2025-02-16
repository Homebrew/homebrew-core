class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.150.0",
      revision: "3ec1aa75d5bf7103b283f46297321a9a4b1a8a33"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2898952b629166e8c5343e44b28741282538612d63611a698125a49d7d28d68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "819602abfa1edc8b5160459157f9907279e0c6b7f2f5681624a00f885411edec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b105f48bea7a90ff74e5379642838fb1c7f7cd0d6d39086fbbe3df148eb4eb73"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc108e36a044f7306d95f122f21df5ab456cf763be6fc96e91aee4fc8f0bad77"
    sha256 cellar: :any_skip_relocation, ventura:       "ccc25f53c6d9aff88b8022dad2b040d4a264a66fb0ea9b27b07a31612a272a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "993e614ba05ca30ecb1372860b81c8597cf15216ccf08f8af9ed759665a0cac1"
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
    system bin/"pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_path_exists testpath/"Pulumi.yaml", "Project was not created"
  end
end
