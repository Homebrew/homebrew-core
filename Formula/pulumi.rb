class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.50.1",
      revision: "818d055a7792ebb3d5291e2a3ccd7fa3c6f32003"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3200291bf482b1ee7635433ce25adbf5e4402de0a8d1a5055c1643bfc3a82a78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b8f62d4e1302b070931e0650098c444cf961ee1f13d451ef90fea21ab047058"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af5a3b66d7291929d83e502859be4fbc5adabac9dff68ba701a687390e21dd7e"
    sha256 cellar: :any_skip_relocation, ventura:        "6b994326f32433ecc10cb35fdeda712b552e8bc6e394e80c5e1e3bf94d0e3c5e"
    sha256 cellar: :any_skip_relocation, monterey:       "f4645280683c74faa9471297aef4535a51f89cd791fed366b43a37390cec12fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "7062d4353de5700d5c0e6f5b85f83b5cb47f95e8f0863104dccbb4b4afe098f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8673273923e5d486d81d9e7e6544a3cd861d402ffa9749dcfad54ff435ccbf8b"
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
