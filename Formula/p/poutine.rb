class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "b74028a79b960cdd9765c4fded68b8734c27b6423e70ac31d37e8850fd6bc930"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4abb7a8040490ead89b53f9b4ba6a6c3f8dfd006d32062d8c1d679fc92e3cfdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6bdf0881b43bd9bcd600037ed185a0a67a8a4997553932948f196b0ce1a5d77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4f554c6c7cfafec1d8693adfbb49766d876ff9a8d67f0e2e113c483757a9e47"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ef48d148f373ba7fee016c7b95abdd29a132d7dc30dba32bbbf9a133023e7b9"
    sha256 cellar: :any_skip_relocation, ventura:        "96685d9f8a039284e838030a38522871f46ed65dc75ec1ae880a422edc46cb08"
    sha256 cellar: :any_skip_relocation, monterey:       "83651f5308754b16a185535e8e9fdcb7d1375c48b28d9b0057530b017eb21f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "def2e8c62352b8bc2b7bd22ea74490ddf73864411967207ed6e24c7b90bb8a91"
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
