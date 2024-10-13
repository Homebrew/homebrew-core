class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "27d9b8dd00223c20334ed923b8183da83e84499efe8250965857447d133d7197"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dab2937ff6c86e9a313e1cd818dd9e646d8678eb602f3a623df8625f02997060"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dab2937ff6c86e9a313e1cd818dd9e646d8678eb602f3a623df8625f02997060"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dab2937ff6c86e9a313e1cd818dd9e646d8678eb602f3a623df8625f02997060"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dab2937ff6c86e9a313e1cd818dd9e646d8678eb602f3a623df8625f02997060"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb2fa60fb704ac26838f998d1d8274b5b1553752bd829e5830a592aa2436a086"
    sha256 cellar: :any_skip_relocation, ventura:        "cb2fa60fb704ac26838f998d1d8274b5b1553752bd829e5830a592aa2436a086"
    sha256 cellar: :any_skip_relocation, monterey:       "cb2fa60fb704ac26838f998d1d8274b5b1553752bd829e5830a592aa2436a086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0476d5625c0d5d326711f440b1e39c7969c9787897807cd13ac6f5194ccd30cb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"poutine", "completion")
  end

  test do
    mkdir testpath/".poutine"
    (testpath/".poutine.yml").write <<~EOS
      include:
      - path: .poutine
      ignoreForks: true
    EOS

    assert_match version.to_s, shell_output("#{bin}/poutine version")

    # Creating local Git repo with vulnerable test file that the scanner can detect
    # This makes no outbound network call and does not read or write outside the of the temp directory
    (testpath/"repo/.github/workflows/").mkpath
    system "git", "-C", testpath/"repo", "init"
    system "git", "-C", testpath/"repo", "remote", "add", "origin", "git@github.com:actions/whatever.git"
    vulnerable_workflow = <<-HEREDOC
    on:
      pull_request_target:
    jobs:
      test:
        runs-on: ubuntu-latest
        steps:
        - uses: actions/checkout@v3
          with:
            ref: ${{ github.event.pull_request.head.sha }}
        - run: make test
    HEREDOC
    (testpath/"repo/.github/workflows/build.yml").write(vulnerable_workflow)
    system "git", "-C", testpath/"repo", "add", ".github/workflows/build.yml"
    system "git", "-C", testpath/"repo", "commit", "-m", "message"
    assert_match "Detected usage of `make`", shell_output("#{bin}/poutine analyze_local #{testpath}/repo")
  end
end
