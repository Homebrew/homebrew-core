class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.119.0",
      revision: "f5989622683b5c2a0e9ead3c0fd7a1c6406dcadb"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6c9e101e8460471bd19a4f87c8d6dfb8679948bf6a7b5830defa6d40717faeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbc623dcc0a475efb7beb0aef1eea9e2f8be80e94c25cc1290f7948a66dbff8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfe7aeb4a579dfce04cc80eed734eeec87744525d9b827c9495b81f2db1497e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfb88be422512b8e9c96edf5c0fcaff39dab23dd825bae2edb87c5344094cb7b"
    sha256 cellar: :any_skip_relocation, ventura:        "f5d85f855d0e1b205e7604c3785a680abd96ee2dbcbe203e0d8f7939bd384239"
    sha256 cellar: :any_skip_relocation, monterey:       "08ad7fe8bd9c7c9d7fb7bcf04f893eb1e2e09b172cf026ecae392fc5bc06aaed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f37e3ef97c8b89214497bb49fb5949390ee22c8a294a2935febe16d0a0fd2c83"
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
