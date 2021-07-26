class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.174.1",
      revision: "a9f076b8fc669dc51e0e94cb1bce9e7ccdf82879"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fef525a00fb37a049e5474003ff2d4856e2538327814f36042d5d049c21228f5"
    sha256 cellar: :any_skip_relocation, big_sur:       "5abe15175a38143be0f41aa8380a30443cef0b523880783248e54eb02fa57925"
    sha256 cellar: :any_skip_relocation, catalina:      "05e292889eb74863a2a647f9a6dd4a3393b7843035b2c20c34dcb784be667df0"
    sha256 cellar: :any_skip_relocation, mojave:        "57e6d3bdbabb826952a5b22e5294a9deaadad30e6b9a800293a6bbd1d46f22d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01e02d0a48e6b111bf2d4635a5bffa1abaaa5a26dd66dbff9a15e5d6565c4b14"
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
