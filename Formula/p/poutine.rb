class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "4f9afcc3b28d1d45a6197347f0b490daccdbaee8b00948c21ac97ddae8becbb3"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3a1d7b6c03e3a65a362b9e0e6b336cda3a9a54596eefe43e225b2f89fd45aa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed1b800dfe6416b29a3d2e7370d2b8975930f7bc67aa19b62f2b92b938643bca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e817a66bbe8aeb126212d5019f3d3cb84bde5e5637931c20904f934a96ccbb48"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfda9e0ac756d2883b94e4c860a28fda2d11d8b5e43d0e3b41c333f1d21e1c25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be5163a1819edf58b6f0d40de0c55018114da3ac14fc2f1b93e898928f0ba6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eabf6bfd4eff9c3e15496c03f3ec9d9705c9add4e2364c10ac2c31640bc0f13d"
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
