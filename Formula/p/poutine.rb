class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "892cd6ad37c2cbee3ae20cb1842787d6c338372836dccf8087eb2bdb08e13b7d"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "650900df417aec95a8b81b0d8eb08dc4645d5b6503fe8aec879faf9b9856bffc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "650900df417aec95a8b81b0d8eb08dc4645d5b6503fe8aec879faf9b9856bffc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "650900df417aec95a8b81b0d8eb08dc4645d5b6503fe8aec879faf9b9856bffc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c658fbe5adc07b25198fbbee42b554c59ccb9317bdb68e5b966fa22442646ef"
    sha256 cellar: :any_skip_relocation, ventura:       "5c658fbe5adc07b25198fbbee42b554c59ccb9317bdb68e5b966fa22442646ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4be118de7e4947ae368b4a1098139b8f6530f19a9f73979015c25580420b4e48"
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
    (testpath/".poutine.yml").write <<~YAML
      include:
      - path: .poutine
      ignoreForks: true
    YAML

    assert_match version.to_s, shell_output("#{bin}/poutine version")

    # Creating local Git repo with vulnerable test file that the scanner can detect
    # This makes no outbound network call and does not read or write outside the of the temp directory
    (testpath/"repo/.github/workflows/").mkpath
    system "git", "-C", testpath/"repo", "init"
    system "git", "-C", testpath/"repo", "remote", "add", "origin", "git@github.com:actions/whatever.git"
    (testpath/"repo/.github/workflows/build.yml").write <<~YAML
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
    YAML
    system "git", "-C", testpath/"repo", "add", ".github/workflows/build.yml"
    system "git", "-C", testpath/"repo", "commit", "-m", "message"
    assert_match "Detected usage of `make`", shell_output("#{bin}/poutine analyze_local #{testpath}/repo")
  end
end
