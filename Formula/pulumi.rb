class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.59.1",
      revision: "20ee7fc734c4fac7b62048e1eb0d67436b64ebbf"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e20145e7309ce1af9cd2d98f0e387f5a2c198090926b1a60d5f6ad5989fadb69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5751a1eb847989dead97728b61a44e35719f53436ccea3de14d65deac57ce782"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9338dc10ffa77cbfc125c208252ae8a59ce6da29611744f5a5f48d9c923fb26"
    sha256 cellar: :any_skip_relocation, ventura:        "92dbe1c139ebb1577a41de431ba84c1b3914278b09aa3aecf5c6941274b1d812"
    sha256 cellar: :any_skip_relocation, monterey:       "41e68309921838f98f473a8b8aa7526aa865f76cfa75089473c8b1d33eed8416"
    sha256 cellar: :any_skip_relocation, big_sur:        "1018d30490436a33e08e3a9b50433ab1ac44583c785f7f3eb3c749f15503f49b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2875f1cbf23fa7204b4be658d9dd9b6d65f90953a60f5e207ba51604564cb532"
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
