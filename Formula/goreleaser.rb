class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.166.0",
      revision: "a2d7ccad2f71a7a050c3d9d3f53bdef2378f2b26"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eb74dae88e9817935fd037fe4cac9ee2ca3516ecc201696f4beba6d5535e34dc"
    sha256 cellar: :any_skip_relocation, big_sur:       "56398d815f5e9ee75ab1b4a60d0f14f32423ecd637f3978f848e41b2ba044f0e"
    sha256 cellar: :any_skip_relocation, catalina:      "78b94a585b5511ad51b49019192c2f0432b7ab3672e9d501ac5a87b787ed6358"
    sha256 cellar: :any_skip_relocation, mojave:        "4d90415225f3b465927a5092444ccecfdc792f678feea1bb462df5cd44ded3cf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=homebrew",
             *std_go_args

    # Install shell completions
    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "bash")
    (bash_completion/"goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "zsh")
    (zsh_completion/"_goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "fish")
    (fish_completion/"goreleaser.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
