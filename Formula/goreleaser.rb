class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.179.0",
      revision: "b654a3116074f4ead2bf6b06898dcf1d0889e1c5"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9aa0516871132d6b4054b61a0c990deff4ad6b05f2b1350dd5321dfeb886bf6d"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca49aa430e661552374a409a24367567ee0699aaedef086fe9a7472cdce077cb"
    sha256 cellar: :any_skip_relocation, catalina:      "f5376bc63de42504c860bef231617ca930fd96a06102e42cc44d26a5b7b922d3"
    sha256 cellar: :any_skip_relocation, mojave:        "396b39d23a084490546f78c4af8dd689332be5e6b8a70899257e521854735851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47ab99cfbf69199956037921794c0afc1d3f914d8dafddd079accd32540c2191"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)

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
