class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.89.0",
      revision: "963a17b094ac1013d4ffdab6bc765a5ed87998b6"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "196981b9460b707c1effb0df30d5de2c49c0e0fd6382d6f0faf8910e14814f51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb119290d38377acd6ab2a2c4b403fdfa7461aacba45535511244abd6dc19da8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36a4ea1e1ec6fb8134a015d02ad158f5c07292f0a647204a5ca174d3edffe17f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5dd04de88bddf5d350795218b2212ff29a4340632493498846bba9f7d96f94f"
    sha256 cellar: :any_skip_relocation, ventura:        "039292ad232ce17b6a8edd832b55105618e04437e23682889e16bc3a28807197"
    sha256 cellar: :any_skip_relocation, monterey:       "ecfa1d495ee68c210186f9df5adc749482690583327f7ebdf9478884820b45b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fe18c98fc3c57f2bac196edaba397edea6eea09e2db5fd9a6c3430964bc34cd"
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
