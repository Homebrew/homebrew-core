class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "3a3c7df89659da4679681c59a1ed96863f99ef2a434422090cdee21e09ba1cb9"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da3b785575f2fc64e9e79f8d7220ca7b8c679e6c9e63f3ec3d7f22f154621566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aff442b64f3646b52d85aef3ccaeb323643b3a2ecc2c70838982daae35a2452f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3a208a618f4862db5b7a7d6f7adde1d3e194081e456a2fe78cf871f6fc4947a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7cc696944c656046a024c93d1758e3e035a0b6b85b566db263b380609b2763a"
    sha256 cellar: :any_skip_relocation, ventura:       "72caa4c0e047d16e47883e9088d184cc2ffc77c9d86e18c47074136dd1d44599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "285b75f5ed9b20964bed0515abfa86b12ab14480b8b44ae06a7e193733d1b30b"
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
