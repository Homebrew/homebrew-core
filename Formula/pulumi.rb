class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.47.1",
      revision: "7a585479bfd51d0933ab67a92530567e10c1b89e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04295f1acb4c05712a7a5a61a2e2c321631cc90de28e60544328d951e187aa3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d4c1835e99e5d942506dec3505741da6ef9d1b275cd57b97a80610df3d0d38a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72f1e3ea149d85d5017af261522edfe992060d7f4ce85aa5ab93996cea2dc2dc"
    sha256 cellar: :any_skip_relocation, ventura:        "69f5568e4d503f246c8b8d138bd98fc3299da66e6346b353fdc73beb9223e280"
    sha256 cellar: :any_skip_relocation, monterey:       "1d5a13b57cee40166af534709306f967c523c6b906285587bb351e1e8bbff439"
    sha256 cellar: :any_skip_relocation, big_sur:        "b98b189c49fd67549be2fd7fb19fdc9bbf3a041ab84f9b4d496c4aa8d9748991"
    sha256 cellar: :any_skip_relocation, catalina:       "13a2c0622c6a05c17ad5a2b7a9b5254a7337ede493d70df61c12468fd664f7f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88a2fd2720f8747009b77d77cd256928f62a726d0827f2b4248009e39160b793"
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
