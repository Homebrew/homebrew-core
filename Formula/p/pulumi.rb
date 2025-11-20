class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.207.0",
      revision: "5e3a50056a84e3c5202b0bd77dce8cd5e70d7e93"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f607dceb913781ef3e102f7b181ddfb30a1872bbf28b7a442b851e4ba2592779"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eb6549359362eb49d9dfa1a9d8134479dbce2fc0b9df22c957347708a9f2db3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16749e4b5c5d1265ffc5b2680ccf36436edfaa8b802908ccb8449af600694d1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9c8c1870cc6bbfbb4c72a06f89207a6182c0494f187f2e128decb68385742fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c89ad9ebae0615b7a407e3912a39c0f2faa309dc1f4e686ac30fa1c44041c241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e022c54518e09ee2d7f99e12bdbfda9788579d0edc6059301e4827923ae74cbf"
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
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    assert_match "Your new project is ready to go!",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes")
  end
end
