class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "85a8ac9a59996ac2749ee0422748c72b38ea033df85956f660004c63d30192ea"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83ffdf6d0949e8546688d70ade14ef959bbba1589bd9b83877f3e65f89dd2aa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "782cb225e983f4330057f8ca2bdea3d45e05b8f1f7603f1d04607caebd7b718c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "913ee25646a1087a758189cbf748c8e9f2dfdb4974858ee2b6b7422bdf9d9851"
    sha256 cellar: :any_skip_relocation, sonoma:         "d76916d6c914a375302d428c69577e8e98889a06c7f824a79ecc32b8d1f493df"
    sha256 cellar: :any_skip_relocation, ventura:        "7080a4fe59b2ecf2fd808424e58b79ef19834113103ed6768eaa282aa1938029"
    sha256 cellar: :any_skip_relocation, monterey:       "0e969044d34aa5698ce451c3563919b17ecfae2af608f0f167800df397d6fa03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aabd7fbd1c32b13811176e1969f2c7ede3cef946db8b81649d2b12f44151aa3d"
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
