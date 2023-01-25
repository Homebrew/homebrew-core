class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.53.1",
      revision: "3dc01efa4cb3763503b32eca659204846db237f3"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9bc8cd4cafeb716f8a2004de4fa3a1c5abc8d05bda4736ffa2df39d30833921"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48ccea0963161b9e782051171fcf7f2c3a87149bcb575d427db7c6f46e301578"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96b7c3f732399c96b7eaf3b2eeeff30092f65d888500fcf13ce9a45ae99aae39"
    sha256 cellar: :any_skip_relocation, ventura:        "62bc2c77b10d28424f30a7246d0daa37a37d29df03c5e72c1a4dccef679c5be4"
    sha256 cellar: :any_skip_relocation, monterey:       "88da9f89b75312677e46450c169fb0b76b383f04bd67818d34fa671f2eaca610"
    sha256 cellar: :any_skip_relocation, big_sur:        "8242ab613b663f5818e8bda361f1db71180940ef7899b4dbfa4a481f1044cafe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0ab9506c07c0488b7e2df7b36f17b44bb480af268cb154fcc14a32571e678e2"
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
