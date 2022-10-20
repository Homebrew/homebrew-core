class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.43.1",
      revision: "91a6b36aa5211ac6d53079dbb36cc001c230510f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9501b8c4d4f4f3e3bc90696ccea88e326baa0db0412ac25d705afc6e2d403344"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb78af945e2b20f08afb132273d4da4fac2fa17a48deffab954ef4f7e1a03b3c"
    sha256 cellar: :any_skip_relocation, monterey:       "49fe144d13d9cb812637455533a8d7ee4e1129043eb26ea04784bdc6e678ea7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ef783b9f42c0786edd40c43d87becbfc3c36286b0194274de70be497fd099f1"
    sha256 cellar: :any_skip_relocation, catalina:       "10f4087541661b2ddc27db1a80e60220e285f01483c17d2310a993bc96a30481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "051c2314416d1b0e33a8aa49c60ae43c4267162fa8ef0e3f3ea7c540186674ea"
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
