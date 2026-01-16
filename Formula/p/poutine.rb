class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "2320a3ab5f25abb4da4bea0591667593b8d7353489a3bfa64d594dfa8c84ff08"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23eb2d15c7fdaa581164fb63673277bcbe2ed836f59ecf89a31db5841bc25ca0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30d1272fab67295395b009135c1771aab1367e9001123d15f3994317f9c0b8b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e4a7a322d1c355cadce567d790d245b24269a08d45d3fa6bf338b73df12e74f"
    sha256 cellar: :any_skip_relocation, sonoma:        "354829a30716b550f324c9e9bd9d7e7a4e5a809b8c66cbf4cb15122ed5380cc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f91d93d812eb65fe7cb368a010b774dbc815b6f6fc5c2a34f9a382e49b8d348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd632bdaccae61dfdb39b05c01c49d70d3c90418dcca71ef27634fee1971758e"
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
