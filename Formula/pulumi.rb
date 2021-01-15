class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.17.2",
      revision: "3853f530d257246a5dadfc055e49abec9d914200"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cf7d702d177dcd3fde49ec623e8b4d1831f27c4444d825844d792ed66b918d3" => :big_sur
    sha256 "50c15e46694f8cc19ba743af34caf436323753cef6975876c9779b70d064577c" => :arm64_big_sur
    sha256 "2c5dd1969ead0c3a7a4ce61347e9c7e3371110f7f874f0790a4e09aaf1e0ab49" => :catalina
    sha256 "d50bfd1a79068706669ee47bfe93808e45831af137d830115cfb43f1d1689bc8" => :mojave
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
