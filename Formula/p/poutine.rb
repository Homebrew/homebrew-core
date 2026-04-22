class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "00309eeba388532c1a4f5ed2eefe31dcd3ec0819bea89cad2cc9b9a08e273b37"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab5319946ca13594ab345a8d7f0894ee97d0a6baed4a6a98aebd1e8ff2e95b03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab5319946ca13594ab345a8d7f0894ee97d0a6baed4a6a98aebd1e8ff2e95b03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab5319946ca13594ab345a8d7f0894ee97d0a6baed4a6a98aebd1e8ff2e95b03"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a080259466459d4ec298cf6e75f8c3cfce06e4021549317adaed35c1b9ccabc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa1794d8b233020e4ed3472ffdd7e1b3dba547ec05569c44d9faffbb0cd108a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee997596cbc369e3967c6dcded55683953142d19054104ec74471d8b6332c09c"
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

    generate_completions_from_executable(bin/"poutine", shell_parameter_format: :cobra)
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
