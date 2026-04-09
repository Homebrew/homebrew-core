class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "acd7cf35456952ca791433961e8819e4df1c2245e4055737102d4d6256981fb2"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92e53ef3f8d4e8a619be26bbddf7df933a3d7ece3e1b6407434dea51e3538ba2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92e53ef3f8d4e8a619be26bbddf7df933a3d7ece3e1b6407434dea51e3538ba2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92e53ef3f8d4e8a619be26bbddf7df933a3d7ece3e1b6407434dea51e3538ba2"
    sha256 cellar: :any_skip_relocation, sonoma:        "426b3c2480e828a12718c0f90d3d1d56c8654f130e0fb8bf4245b44ddee22be5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7c98f8f16575eaa10e1d7d3c65a723425a418894ace8493b71966a7af79ba0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf074ea11ac5cb106046e635c4542120d55d6aa02417a2826686d4daa27dfdd7"
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
