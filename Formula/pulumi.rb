class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.33.1",
      revision: "03baa3e5f645dcae02a970c85028fd082f0480c8"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce92d35df36106da4c3142e10b21c00fe38a41e9a258b46ce53393c49af5e827"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d10ad2716d756bb939ab9e777edf7cd0e962b6c7297fa2b647be52670303babd"
    sha256 cellar: :any_skip_relocation, monterey:       "8488fc8d4f4f5cc8b453b7340b93399a279199b3d4211f24dccfb68eca568074"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cb2e05b38cf924e9b16fcac3e478142ff8ebf10066a2948cc80bcd51a677929"
    sha256 cellar: :any_skip_relocation, catalina:       "b676ae39274ece491b07a0c0864c85ea320deefcf6a780fef067a748163cdb3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b84060bc6fd256c985f0bec0b9dbe0594089858b258ec8d56cf4c4fd657ac57"
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
