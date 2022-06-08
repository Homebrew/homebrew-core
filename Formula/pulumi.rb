class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.34.0",
      revision: "2baf8da48532f1020e7ff81f0cfa3601bc863634"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abbdb09fff35232432a58456528fe8d04ccda023d3ff8909f63530f5f52e95cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "705509887b732ea129458b0e6a7bfa7a1de0f7f7263364565b905774a78c86f2"
    sha256 cellar: :any_skip_relocation, monterey:       "ef40a6a7455f7f2e44fb3293d7f6944b4950ca5e5e0604ce19a9550a412a094e"
    sha256 cellar: :any_skip_relocation, big_sur:        "05aa8b4212c48901212612a98495d1bbc10ae1771bda8c9033a9ff52e9750fd5"
    sha256 cellar: :any_skip_relocation, catalina:       "aa00522d12a5a39b129099a23975aa2936d66c5f4e56cd15f757d0a6efbde058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6df48b1a0bad57e7d783e726e569d9452a406a6805d5ce71e7c5538e4ee7a2fe"
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
    (bash_completion/"pulumi.bash").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "bash")
    (zsh_completion/"_pulumi").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "zsh")
    (fish_completion/"pulumi.fish").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "fish")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
