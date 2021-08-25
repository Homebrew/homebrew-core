class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.176.0",
      revision: "dd5ccf7170741e0303e90e81faf9073d03ac8f43"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "66c33e89ec35c725777e190dc18b32fd260424a81975371f08988631a9a6eebd"
    sha256 cellar: :any_skip_relocation, big_sur:       "6ea6fef8780ea09da388392879b2538856d41962dc9b8018644672ce673fe8e4"
    sha256 cellar: :any_skip_relocation, catalina:      "faa1acf97493189ee8055f60396ab816fd75ddafd92efa5e3e9b9648fde5fd6b"
    sha256 cellar: :any_skip_relocation, mojave:        "3091d4670b2bdfad76352a8cfa2c797961442836ceae4a5a660679812b88faf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f7e67ca31f44136027db1ba598ee3b5e3a219fa675eed3af097c023610bb7e7"
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
