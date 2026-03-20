class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "86d3ba3e1a5ab9046b8bbf52f89fecbcb5cf9e4c43a3611f9ce39caff9eecad1"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bee380c7d222906d0f81c486b0fbc43dd37851ef42c46d20aafb65fb61bfeb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b183657a602c0c0b30247cb96c7c09d7d8c4757c47bb9cd468806ea990bc6a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef7f320850a970d3f33ba78d183e8efd10ce061350004e5317edd23c232bbefe"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ee7187db58b70a21456a4b8fed0a54875ca87b65fddf2fa11a2b7f8bebc2c74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a1c67753cad06511f711b697152b59502cf2b7d86620677d5609cd15db48714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d12e63b971324d50593d81375dc0041dc7cc68877c7234a84fba5700033a0d8c"
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
