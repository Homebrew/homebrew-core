class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.51.1",
      revision: "7efd298867cbbaebf3c8c333e6816e1ea48837ef"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "037ef07ef7fb859d9cb28fc3d89acccd018f325bd32c28e36bf74a945e5b8273"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2087dee7dd1355c09b5a843729216dc65bfbc5e84b0dc48323c8edf4c9cac158"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e232c39dc96a2410e50cf021aa56935e7d2165bcd51b611059068627250968e"
    sha256 cellar: :any_skip_relocation, ventura:        "862ee74b91c9718ce72420f6dd154661816fc87d7eaf5f35b87b4b6009c03cb0"
    sha256 cellar: :any_skip_relocation, monterey:       "e9b07eaab9e4c5abdf8c176169c7d82f34e3872df857e497785b76de5127f386"
    sha256 cellar: :any_skip_relocation, big_sur:        "ece70e1c9a59f1fb236e9121345eac37bd4d86876001cb9d0612c3ab94dbe850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9e2370ff6e770c4e62552f1fb16fb16f73a748a624dbc03419bb32cdf1b59f9"
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
