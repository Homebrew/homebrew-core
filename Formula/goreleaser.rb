class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.9.2",
      revision: "b869ea44b7e211c59d856307a5d308b594030218"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "184459318155f699c8d63f0c6d779d33239fe34abaa184e0a00e449b9f3a9697"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "596d74a03415d72d79fc774b69ceab8a4dbdebe534fc4005172bfd2360184ba7"
    sha256 cellar: :any_skip_relocation, monterey:       "2c7bdea3b73a99ed4bbcd1704aa35ac3024402a27476273e01df569759db48f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "03e658072106cc4f94b81846aa306d85201b216277aae7453bbc4fa5a46ca923"
    sha256 cellar: :any_skip_relocation, catalina:       "ed5cdd6178e6e16bedf78fbb1861270f6f8539b1017a3f13c08cda640b043a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e63b43901a832a15b53ede138a755a6d953a74ffe071b8f03ac3d0a036b80c1a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

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
