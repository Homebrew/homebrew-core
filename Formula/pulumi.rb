class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.56.0",
      revision: "e145adc27c6bb41e922db3846324205333256436"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0468c2faf576d2261d06dfb0f75c1f5e7e8f2e7763918568838865ea90d45064"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20b85277985748af88874c3902acb2fb13aa0a19fecf0c43c396a1e1889fac08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6bc73007c38c106091e95e880b71f7899490190b22513ac656c5550f4c3ff51"
    sha256 cellar: :any_skip_relocation, ventura:        "9b8a4e68344f7997d338854f7fb64a0156068f5bda4619335024ba193ed69e18"
    sha256 cellar: :any_skip_relocation, monterey:       "fc5b3fc8b8570a5cf4baca12c45827ea5a6ae283148b6fff119b57657615c87f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f15d2a26f26ce190d404a63563ec79cb1b339d6537a64d43009f30f2881c72f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a7f9fb6cb7e181343ff81faf7bad48bd782d5065fb05baf3e6ba16973862847"
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
