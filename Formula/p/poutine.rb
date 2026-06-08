class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "3ef79da4e8e64398e3acf8ba6f9adb88917ddbfa025f1352eecfd0b3903c7920"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db72a5ae20e78380b764f78254d9d123495c27e84d96422850dbb1ecbba6a201"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db72a5ae20e78380b764f78254d9d123495c27e84d96422850dbb1ecbba6a201"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db72a5ae20e78380b764f78254d9d123495c27e84d96422850dbb1ecbba6a201"
    sha256 cellar: :any_skip_relocation, sonoma:        "da4b821e142c04c0b4beb8d44bb21370663a692ecc8fa11f28dfc3c9f06d1030"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79872fbde4e7da5ce9c2776f45a0e343859d71042818a6c7c672fd8798677430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "773da1601ff91ff8187ea8eab5f0bcb23e40d13371e51d6149c531605a4fc647"
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
