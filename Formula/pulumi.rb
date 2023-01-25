class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.53.0",
      revision: "fe17b9db823322aec4e2a0214b1cc984f8ef7db2"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "449704a93b0f7326596de5ccd2ad080af73673ddabf1ae07717e21eae62225b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "148e3144bc8bcf3de53846d089fc5ba6b7f09239a93317ef1c60c352a89f6fa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4822579f5fcfbac082c419b44f9d9f229b0faacf0e8744702fa6e719d944f212"
    sha256 cellar: :any_skip_relocation, ventura:        "d409aa5e35e1256c2210f79b630acfed781d53dd79cb9075a1c0cf308982d88d"
    sha256 cellar: :any_skip_relocation, monterey:       "9567f8b2f3e73a9ceeed62966ed3d5f641f61e25c0acde7d76a555175e049e53"
    sha256 cellar: :any_skip_relocation, big_sur:        "29c6ecb6394903d323de3a2fb8824a3450b61136fadde93f3ef959730bbbd2f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c12470fcd0499e7deda1b4981f05d354849d875ebb5e76a6870b88eafe1a82e"
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
