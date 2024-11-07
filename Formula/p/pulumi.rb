class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.138.0",
      revision: "924ce61d722e0607c9e8de56f592c2a599978fac"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1588b328bfa43bc45b3a249e5dcd986996a4bd59abcda89ae58ee8a793f93a71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ada772266dd2f337b2f2c506ead62bfaf243bda3aea1e0a7583c0aea37a56ad6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98b3827540ce33530b6ed86b6bde7eeec7f21187d1524c6994bbf8213e46162b"
    sha256 cellar: :any_skip_relocation, sonoma:        "48c99e09d0f08c17e9d1b195737e4c68feddf00b1fa0e7eb79191ead71b0b811"
    sha256 cellar: :any_skip_relocation, ventura:       "fd421b451c4e7caf5c6ff36cb2d8ede7f6169c9f93dcc03ae1de8791f8c99357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d66eec0bd3418a8847a41aa71377caf2bb07b4acdfb7e9ca3b982f6d74f650d2"
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
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
