class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.4.1",
      revision: "a1447a363579365f489458ad7636fd088a5b66ab"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03d3c035e210b01c2bf512944e3bc80aebc5329b520aa22a916a8f635f2eefaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "947282628eabbead562d8a9ff00b216a5b8414efa9534233ebbd9cfe50cbd45c"
    sha256 cellar: :any_skip_relocation, monterey:       "76526a37967bba5e1271ba091effa5c855983e7b40be224073914a75726cbf06"
    sha256 cellar: :any_skip_relocation, big_sur:        "71f22ef690bda92dc1bf43e58ebc4341fbd5ff24aa05d3eb16e12f459a59f5c8"
    sha256 cellar: :any_skip_relocation, catalina:       "cea05e74bfbe77263634d3e75296a00715a840a67d9dc81016f9573736b3e197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "546e3a23be8b5ceb3468644b05b880f00a32f0abeb7978bccc8c517e30403360"
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
