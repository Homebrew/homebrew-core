class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://github.com/boostsecurityio/poutine/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "6d98171b2c4100d2677c219258fcd1c00b6ef184f9cb5994e0cacb3a0ac30b47"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a68b0e4d2eb59afbf494b16aa9924e7b8e84d385ec63eb842dc0a400b984491"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40314a9f7b10a379035b65cbd619f5647deac536e39fe6c98eb77e77514ea635"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83e057f632d96a7e3ccc2f2ec6576c0f7c01fa9920f44770494c5387daedcfd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "edf15bb654cf74c0fea4ec087fa930a9ce81ae0f3b6f05f691e7fc960de88aec"
    sha256 cellar: :any_skip_relocation, ventura:       "a77e2d668fd598fb00138d3a04a82c3a9e41cb65bb5e3d50121863d7a577bdfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e043de17490b9eb9b7f7b785fd423ee0ee8115378056c8e76bb2a98f53c86db7"
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
