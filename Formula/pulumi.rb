class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.47.2",
      revision: "6c046a9fbc96e9e15121eb6af86da58efc31a425"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "471af89878a4db341cdbae99391f8ed0c30e87f6a9ede2e59076b4cfea09785f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66f170f982b4983ec3e2608f79fed7f78e3ed9a127b10ff7cdbabbf2620b4e4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86ee82ae91992c24514843495ab95c050780876ef88f4fddd91fb4a1f4fdb3ce"
    sha256 cellar: :any_skip_relocation, ventura:        "2223a7f5e8f8944b0ad610b1c1e5134d71e9a401a6fd04b4e68fc9c4263dbf40"
    sha256 cellar: :any_skip_relocation, monterey:       "c76f803bd1339d8a6d80fc81bbdb86fc04f82684a9cecc7f6917319bd217535f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f922fa24d5880af2a32b8e9981c3dfc835248e341bf7547a2743996db96b108e"
    sha256 cellar: :any_skip_relocation, catalina:       "ca31d543b193bc375a8058007917707b1d0a6024ce29fbb18fe2c83869dacf86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "876f23694271cfe6407bb0b6c6ecdf9bc3d78a26bb878e27b7447e4658aea6fd"
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
